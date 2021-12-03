import logging
import config
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


# States
class FormClient(StatesGroup):
    choose = State()
    name = State()  # Will be represented in storage as 'Form:name'
    email = State()
    number = State()
    item = State()
    duration = State()


class FormOwner(StatesGroup):
    name = State()
    email = State()
    free_space = State()
    price = State()


@dp.message_handler(commands="start")
async def cmd_start(message: types.Message):
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    buttons = ["Сдавать", "Арендовывать"]
    keyboard.add(*buttons)
    await message.answer("Что вы собираетесь делать?", reply_markup=keyboard)


@dp.message_handler(Text(equals="Сдавать"))
async def menu(message: types.Message):
    await message.reply("Хорошо", reply_markup=types.ReplyKeyboardRemove())
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    buttons = ["Добавить"]
    keyboard.add(*buttons)
    buttons = ["Посмотреть уже добавленные"]
    keyboard.add(*buttons)
    await message.answer("Меню", reply_markup=keyboard)


@dp.message_handler(Text(equals="Добавить"))
async def second_menu(message: types.Message):
    await FormOwner.name.set()
    await message.reply("Ну начнём. \nКак к вам обращаться?", reply_markup=types.ReplyKeyboardRemove())


@dp.message_handler(lambda message: message.text == "Арендовывать")
async def second_menu(message: types.Message):
    await message.reply("Хорошо", reply_markup=types.ReplyKeyboardRemove())
    await FormClient.choose.set()
    await message.reply("Как к вам обращаться?")


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
    await message.reply('Cancelled.', reply_markup=types.ReplyKeyboardRemove())


@dp.message_handler(state=FormOwner.name)
async def process_name(message: types.Message, state: FSMContext):
    """
    Process user name
    """
    async with state.proxy() as data_owner:
        data_owner['name'] = message.text

    await FormOwner.next()
    await message.reply("Введите ваш email")


@dp.message_handler(state=FormOwner.email)
async def process_email(message: types.Message, state: FSMContext):
    async with state.proxy() as data_owner:
        data_owner['email'] = message.text

    await FormOwner.next()
    await message.reply("Сколько места на вашем складе в квадратных метрах?")


# Check age. Age gotta be digit
@dp.message_handler(lambda message: not message.text.isdigit(), state=FormOwner.free_space)
async def set_space_invalid(message: types.Message):
    return await message.reply("Это должна быть цифра!.\nСколько места на вашем складе в квадратных метрах?")


@dp.message_handler(lambda message: message.text.isdigit(), state=FormOwner.free_space)
async def set_space(message: types.Message, state: FSMContext):
    # Update state and data
    await FormOwner.next()
    await state.update_data(free_space=int(message.text))

    await message.reply("Какую ежемесячную плату в рублях вы хотите поставить?")


@dp.message_handler(lambda message: not message.text.isdigit(), state=FormOwner.price)
async def set_price_invalid(message: types.Message):
    return await message.reply("Это должна быть цифра!.\nКакую ежемесячную плату в рублях вы хотите поставить?")


@dp.message_handler(lambda message: message.text.isdigit(), state=FormOwner.price)
async def set_price(message: types.Message, state: FSMContext):

    await state.update_data(price=int(message.text))
    async with state.proxy() as data:
        data['gender'] = message.text

        # Remove keyboard
        markup = types.ReplyKeyboardRemove()

        # And send message
        await bot.send_message(
            message.chat.id,
            md.text(
                md.text('Hi! Nice to meet you,', md.bold(data['name'])),
                md.text('Email:', data['email']),
                md.text('Free space:', data['free_space']),
                md.text('price:', data['price']),
                sep='\n',
            ),
            reply_markup=markup,
            parse_mode=ParseMode.MARKDOWN,
        )

    # Finish conversation
    await state.finish()


if __name__ == '__main__':
    executor.start_polling(dp, skip_updates=True)