import logging
import config
from project import *
import aiogram.utils.markdown as md
from aiogram import Bot, Dispatcher, types
from aiogram.contrib.fsm_storage.memory import MemoryStorage
from aiogram.dispatcher import FSMContext
from aiogram.dispatcher.filters import Text
from aiogram.dispatcher.filters.state import State, StatesGroup
from aiogram.types import ParseMode
from aiogram.utils import executor

logging.basicConfig(level=logging.INFO)

bot = Bot(token=config.token)

# For example use simple MemoryStorage for Dispatcher.
storage = MemoryStorage()
dp = Dispatcher(bot, storage=storage)

connection = create_connection()
connection.autocommit = True


# States
class FormState(StatesGroup):
    name = State()
    email = State()
    confirm = State()
    choose = State()


class FormClient(StatesGroup):
    menu = State()
    item = State()
    choose = State()
    duration = State()


class FormOwner(StatesGroup):
    menu = State()
    delete = State()
    free_space = State()
    price = State()


class FormAdmin(StatesGroup):
    menu = State()
    do_admin = State()
    delete = State()

@dp.message_handler(state='*', commands='start')
@dp.message_handler(commands="start")
async def cmd_start(message: types.Message):
    global connection
    print(message.chat.id)
    if is_user_owner(connection, message.chat.id):
        await FormOwner.menu.set()
        keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
        buttons = ["Добавить", "Посмотреть уже добавленные склады", "Удалить", "Мои контракты"]
        keyboard.add(*buttons)
        await message.answer("Меню", reply_markup=keyboard)
    elif is_user_client(connection, message.chat.id):
        await FormClient.menu.set()
        keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
        buttons = ["Арендовать помещение", "Посмотреть свои контракты", "Мои вещи"]
        keyboard.add(*buttons)
        await message.answer("Меню", reply_markup=keyboard)
    else:
        add_new_user(connection, message.chat.id)
        await FormState.name.set()
        await message.answer("Введите ваше имя")


@dp.message_handler(state='*', commands='admin')
@dp.message_handler(Text(equals='admin', ignore_case=True), state='*')
async def admin_panel(message: types.Message):
    global connection
    if is_user_admin(connection, message.chat.id):
        await FormAdmin.menu.set()
        keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
        buttons = ["Clear sklad_owner", "Clear skladi", "Clear contracts", "email delete"]
        keyboard.add(*buttons)
        buttons = ["clear client", "clear items", "clear skladi_client", "clear all_users"]
        keyboard.add(*buttons)
        buttons = ["clear all", "all users", "do admin", "show clients", "back"]
        keyboard.add(*buttons)
        await message.answer("Меню", reply_markup=keyboard)


@dp.message_handler(state=FormAdmin.menu)
async def menu(message: types.Message):
    global connection
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    buttons = ["Clear sklad_owner", "Clear skladi", "Clear contracts", "email delete"]
    keyboard.add(*buttons)
    buttons = ["clear client", "clear items", "clear skladi_client", "clear all_users"]
    keyboard.add(*buttons)
    buttons = ["clear all", "all users", "do admin", "show clients", "back"]
    keyboard.add(*buttons)
    await message.answer("Меню", reply_markup=keyboard)
    if message.text == 'Clear sklad_owner':
        truncate_sklad_owner(connection)
    if message.text == 'Clear skladi':
        truncate_skladi(connection)
    if message.text == 'Clear contracts':
        truncate_contracts(connection)
    if message.text == 'clear client':
        truncate_client(connection)
    if message.text == 'clear items':
        truncate_items(connection)
    if message.text == 'clear skladi_client':
        truncate_skladi_client(connection)
    if message.text == 'clear all_users':
        truncate_all_users(connection)
    if message.text == 'clear all':
        truncate_all(connection)
    if message.text == 'email delete':
        await message.answer("input email for delete")
        await FormAdmin.delete.set()
    if message.text == 'all users':
        text = info_about_all_users(connection)
        await message.answer(text)
    if message.text == 'show clients':
        text = show_all_clients(connection)
        await message.answer(text)
    if message.text == 'do admin':
        await FormAdmin.next()
        await message.answer("Введите id пользователя и True/False")
    if message.text == 'back':
        await message.answer("Для выхода введите команду /cancel , а затем /start")


@dp.message_handler(state=FormAdmin.delete)
async def delete(message: types.Message):
    global connection
    del_client(connection, message.text)
    await message.answer("deleted")
    await FormAdmin.menu.set()


@dp.message_handler(state=FormAdmin.do_admin)
async def admin(message: types.Message):
    global connection
    arg = message.text.split()
    print(arg)
    edit_user_status(connection, int(arg[0]), bool(arg[1]))
    await FormAdmin.menu.set()
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    buttons = ["Clear sklad_owner", "Clear skladi", "Clear contracts", "email delete"]
    keyboard.add(*buttons)
    buttons = ["clear client", "clear items", "clear skladi_client", "clear all_users"]
    keyboard.add(*buttons)
    buttons = ["clear all", "all users", "do admin", "show clients", "back"]
    keyboard.add(*buttons)
    await message.answer("Меню", reply_markup=keyboard)


# add new
@dp.message_handler(state=FormState.name)
async def process_name(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['name'] = message.text
    await FormState.email.set()
    await message.reply("Введите ваш email")


@dp.message_handler(state=FormState.email)
async def process_email(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['email'] = message.text
    await FormState.next()
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    buttons = ["Да", "Нет"]
    keyboard.add(*buttons)
    async with state.proxy() as data:
        await message.answer(f"{data['name']} {data['email']} всё так?", reply_markup=keyboard)


@dp.message_handler(state=FormState.confirm)
async def confirm(message: types.Message, state: FSMContext):
    if message.text == 'Да':
        await FormState.next()
        keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
        buttons = ["Сдавать", "Арендовывать"]
        keyboard.add(*buttons)
        await message.answer("Что вы собираетесь делать?", reply_markup=keyboard)
    if message.text == 'Нет':
        await FormState.name.set()
        await message.answer("Введите ваше имя")


@dp.message_handler(state=FormState.choose)
async def choose(message: types.Message, state: FSMContext):
    global connection
    async with state.proxy() as data:
        if message.text == 'Сдавать':
            await FormOwner.menu.set()
            add_new_owner(connection, message.chat.id, data['name'], data['email'])
            keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
            buttons = ["Добавить", "Посмотреть уже добавленные склады", "Удалить", "Мои контракты"]
            keyboard.add(*buttons)
            await message.answer("Меню", reply_markup=keyboard)
        if message.text == 'Арендовывать':
            await FormClient.menu.set()
            add_new_client(connection, message.chat.id, data['name'], data['email'])
            keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
            buttons = ["Арендовать помещение", "Посмотреть свои контракты", "Мои вещи"]
            keyboard.add(*buttons)
            await message.answer("Меню", reply_markup=keyboard)

# for owner
@dp.message_handler(state=FormOwner.menu)
async def menu(message: types.Message):
    global connection
    if message.text == 'Добавить':
        await FormOwner.free_space.set()
        await message.reply("Сколько места на вашем складе в квадратных метрах?")
    if message.text == 'Посмотреть уже добавленные склады':
        text = info_about_owner_sklads(connection, message.chat.id)
        for sklad in text:
            await message.answer(f"Номер склада {sklad[0]}\nСвободное место {sklad[2]}\nВсего места {sklad[3]}\nЦена за месяц {sklad[4]}")
        keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
        buttons = ["Добавить", "Посмотреть уже добавленные склады", "Удалить", "Мои контракты"]
        keyboard.add(*buttons)
        await message.answer("Меню", reply_markup=keyboard)
    if message.text == 'Мои контракты':
        text = info_about_owner_contracts(connection, message.chat.id)
        for contract in text:
            await message.answer(f"Номер склада {contract[1]}\nПользователь {contract[2]}\nПродолжительность аренды {contract[3]}\nЦена {contract[4]}\n")
        keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
        buttons = ["Добавить", "Посмотреть уже добавленные склады", "Удалить", "Мои контракты"]
        keyboard.add(*buttons)
    if message.text == 'Удалить':
        await FormOwner.delete.set()
        await message.reply("Напишите номер того, какой хотите удалить")


# add new sklad
@dp.message_handler(lambda message: not message.text.isdigit(), state=FormOwner.free_space)
async def set_space_invalid(message: types.Message):
    return await message.reply("Это должна быть цифра!.\nСколько места на вашем складе в квадратных метрах?")


@dp.message_handler(lambda message: message.text.isdigit(), state=FormOwner.free_space)
async def set_space(message: types.Message, state: FSMContext):
    await FormOwner.price.set()
    await state.update_data(free_space=int(message.text))
    await message.reply("Какую ежемесячную плату в рублях вы хотите поставить?")


@dp.message_handler(lambda message: not message.text.isdigit(), state=FormOwner.price)
async def set_price_invalid(message: types.Message):
    return await message.reply("Это должна быть цифра!.\nКакую ежемесячную плату в рублях вы хотите поставить?")


@dp.message_handler(lambda message: message.text.isdigit(), state=FormOwner.price)
async def set_price(message: types.Message, state: FSMContext):
    global connection
    await state.update_data(price=int(message.text))
    async with state.proxy() as data:
        add_new_sklad(connection, message.chat.id, data['free_space'], data['free_space'], data['price'])
        await message.reply("Отлично, добавил")
    await FormOwner.menu.set()
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    buttons = ["Добавить", "Посмотреть уже добавленные склады", "Удалить", "Мои контракты"]
    keyboard.add(*buttons)
    await message.answer("Меню", reply_markup=keyboard)

# delet sklad
@dp.message_handler(state=FormOwner.delete)
async def delete(message: types.Message):
    global connection
    del_sklad(connection, message.text)
    await message.reply("Готово")
    await FormOwner.menu.set()
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    buttons = ["Добавить", "Посмотреть уже добавленные склады", "Удалить", "Мои контракты"]
    keyboard.add(*buttons)
    await message.answer("Меню", reply_markup=keyboard)


# You can use state '*' if you need to handle all states
@dp.message_handler(state='*', commands='cancel')
@dp.message_handler(Text(equals='cancel', ignore_case=True), state='*')
async def cancel_handler(message: types.Message, state: FSMContext):
    """
    Allow user to cancel any action
    """
    current_state = await state.get_state()
    if current_state is None:
        return

    logging.info('Cancelling state %r', current_state)
    # Cancel state and inform user about it
    await state.finish()
    # And remove keyboard (just in case)
    await message.reply('Отменен, пропишите /start', reply_markup=types.ReplyKeyboardRemove())


# for client
@dp.message_handler(state=FormClient.menu)
async def menu(message: types.Message):
    global connection
    if message.text == 'Арендовать помещение':
        await FormClient.item.set()
        await message.reply("Укажите предметы и сколько места они занимают(м^2) в формате: предмет1 = x, предмет2 = x")
    if message.text == 'Посмотреть свои контракты':
        text = info_about_client_contracts(connection, message.chat.id)
        for contract in text:
            await message.answer(f"Склад: {contract[1]}\nпродолжительность аренды: {contract[3]}\nцена за аренду: {contract[4]}")
        keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
        buttons = ["Арендовать помещение", "Посмотреть свои контракты", "Мои вещи"]
        keyboard.add(*buttons)
        await message.answer("Меню", reply_markup=keyboard)
    if message.text == 'Мои вещи':
        text = info_about_items(connection, message.chat.id)
        for item in text:
            await message.answer(f"{item[1]}\n{item[2]}")
        keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
        buttons = ["Арендовать помещение", "Посмотреть свои контракты", "Мои вещи"]
        keyboard.add(*buttons)
        await message.answer("Меню", reply_markup=keyboard)


@dp.message_handler(state=FormClient.item)
async def set_space(message: types.Message, state: FSMContext):
    # Update state and data
    global connection
    items = message.text.split(", ")
    list_of_items = {}
    for elem in items:
        temp = elem.split(" = ")
        list_of_items[temp[0]] = temp[1]
        add_new_item(connection, temp[0], temp[1], message.chat.id)
    async with state.proxy() as data_client:
        data_client['items'] = list_of_items
    await FormClient.next()
    await message.reply("Отлично! Осталось выбрать подходящего арендодателя\nНапишите номер выбранного склада")
    text = available_sklads(connection, message.chat.id)
    for sklad in text:
        await message.answer(f"номер склада {sklad[0]} цена за месяц {sklad[4]}\n")



@dp.message_handler(state=FormClient.choose)
async def set_price(message: types.Message, state: FSMContext):
    await message.reply("Введите продолжительность аренды в месяцах")
    await FormClient.next()
    async with state.proxy() as data_client:
        data_client['sklad'] = message.text


@dp.message_handler(state=FormClient.duration)
async def set_price(message: types.Message, state: FSMContext):
    global connection
    async with state.proxy() as data_client:
        data_client['dur'] = message.text
        add_new_contract(connection, data_client['sklad'], message.chat.id, data_client['dur'])
        calculate_free_space(connection, message.chat.id, data_client['sklad'])
    await FormClient.menu.set()
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    buttons = ["Арендовать помещение", "Посмотреть свои контракты", "Мои вещи"]
    keyboard.add(*buttons)
    await message.answer("Меню", reply_markup=keyboard)




if __name__ == '__main__':
    executor.start_polling(dp, skip_updates=True)