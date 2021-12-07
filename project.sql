PGDMP     0    /                 y         
   bd_project    14.1    14.1 $    %           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            &           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            '           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            (           1262    16808 
   bd_project    DATABASE     g   CREATE DATABASE bd_project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Russian_Russia.1251';
    DROP DATABASE bd_project;
                postgres    false            �            1255    16916    calc_total()    FUNCTION     �  CREATE FUNCTION public.calc_total() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	total int;
	price int;
	rent_dur int;
	id_ int;
begin
	id_ = new.contract_id;
	rent_dur = new.rent_duration;
	select price_for_one_month into price from skladi where skladi.sklad_id = new.sklad_id;
	total = price::integer * rent_dur;
	
	update contracts set total_price = total
	where contract_id = id_;
	return new;
end;
$$;
 #   DROP FUNCTION public.calc_total();
       public          postgres    false            �            1259    16854 	   all_users    TABLE     d   CREATE TABLE public.all_users (
    user_id integer NOT NULL,
    is_admin boolean DEFAULT false
);
    DROP TABLE public.all_users;
       public         heap    postgres    false            �            1259    16824    client    TABLE     �   CREATE TABLE public.client (
    client_id integer NOT NULL,
    client_name character(100) NOT NULL,
    client_email character(100) NOT NULL
);
    DROP TABLE public.client;
       public         heap    postgres    false            �            1259    16901 	   contracts    TABLE     �   CREATE TABLE public.contracts (
    contract_id integer NOT NULL,
    sklad_id integer NOT NULL,
    client_id integer NOT NULL,
    rent_duration integer NOT NULL,
    total_price integer
);
    DROP TABLE public.contracts;
       public         heap    postgres    false            �            1259    16844    items    TABLE     �   CREATE TABLE public.items (
    item_id integer NOT NULL,
    item_name character(100) NOT NULL,
    item_space smallint NOT NULL,
    owner integer NOT NULL
);
    DROP TABLE public.items;
       public         heap    postgres    false            �            1259    16920    price    TABLE     ?   CREATE TABLE public.price (
    price_for_one_month integer
);
    DROP TABLE public.price;
       public         heap    postgres    false            �            1259    16809    sklad_owner    TABLE     �   CREATE TABLE public.sklad_owner (
    owner_id integer NOT NULL,
    owner_name character(100) NOT NULL,
    owner_email character(100) NOT NULL
);
    DROP TABLE public.sklad_owner;
       public         heap    postgres    false            �            1259    16814    skladi    TABLE     �   CREATE TABLE public.skladi (
    sklad_id integer NOT NULL,
    owner_id integer NOT NULL,
    free_space smallint,
    total_space smallint NOT NULL,
    price_for_one_month integer DEFAULT 0
);
    DROP TABLE public.skladi;
       public         heap    postgres    false            �            1259    16829    skladi_client    TABLE     e   CREATE TABLE public.skladi_client (
    sklad_id integer NOT NULL,
    client_id integer NOT NULL
);
 !   DROP TABLE public.skladi_client;
       public         heap    postgres    false                       0    16854 	   all_users 
   TABLE DATA           6   COPY public.all_users (user_id, is_admin) FROM stdin;
    public          postgres    false    214   o)                 0    16824    client 
   TABLE DATA           F   COPY public.client (client_id, client_name, client_email) FROM stdin;
    public          postgres    false    211   �)       !          0    16901 	   contracts 
   TABLE DATA           a   COPY public.contracts (contract_id, sklad_id, client_id, rent_duration, total_price) FROM stdin;
    public          postgres    false    215   �)                 0    16844    items 
   TABLE DATA           F   COPY public.items (item_id, item_name, item_space, owner) FROM stdin;
    public          postgres    false    213   �)       "          0    16920    price 
   TABLE DATA           4   COPY public.price (price_for_one_month) FROM stdin;
    public          postgres    false    216   �)                 0    16809    sklad_owner 
   TABLE DATA           H   COPY public.sklad_owner (owner_id, owner_name, owner_email) FROM stdin;
    public          postgres    false    209   *                 0    16814    skladi 
   TABLE DATA           b   COPY public.skladi (sklad_id, owner_id, free_space, total_space, price_for_one_month) FROM stdin;
    public          postgres    false    210   "*                 0    16829    skladi_client 
   TABLE DATA           <   COPY public.skladi_client (sklad_id, client_id) FROM stdin;
    public          postgres    false    212   ?*       �           2606    16859    all_users all_users_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.all_users
    ADD CONSTRAINT all_users_pkey PRIMARY KEY (user_id);
 B   ALTER TABLE ONLY public.all_users DROP CONSTRAINT all_users_pkey;
       public            postgres    false    214            �           2606    16828    client client_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (client_id);
 <   ALTER TABLE ONLY public.client DROP CONSTRAINT client_pkey;
       public            postgres    false    211            �           2606    16905    contracts contracts_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (contract_id);
 B   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_pkey;
       public            postgres    false    215            �           2606    16848    items items_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (item_id);
 :   ALTER TABLE ONLY public.items DROP CONSTRAINT items_pkey;
       public            postgres    false    213            |           2606    16813    sklad_owner sklad_owner_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.sklad_owner
    ADD CONSTRAINT sklad_owner_pkey PRIMARY KEY (owner_id);
 F   ALTER TABLE ONLY public.sklad_owner DROP CONSTRAINT sklad_owner_pkey;
       public            postgres    false    209            �           2606    16833     skladi_client skladi_client_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.skladi_client
    ADD CONSTRAINT skladi_client_pkey PRIMARY KEY (sklad_id, client_id);
 J   ALTER TABLE ONLY public.skladi_client DROP CONSTRAINT skladi_client_pkey;
       public            postgres    false    212    212            ~           2606    16818    skladi skladi_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.skladi
    ADD CONSTRAINT skladi_pkey PRIMARY KEY (sklad_id);
 <   ALTER TABLE ONLY public.skladi DROP CONSTRAINT skladi_pkey;
       public            postgres    false    210                       1259    16890    client_name    INDEX     E   CREATE INDEX client_name ON public.client USING btree (client_name);
    DROP INDEX public.client_name;
       public            postgres    false    211            z           1259    16891 
   owner_name    INDEX     H   CREATE INDEX owner_name ON public.sklad_owner USING btree (owner_name);
    DROP INDEX public.owner_name;
       public            postgres    false    209            �           2620    16949    contracts calc_total    TRIGGER     n   CREATE TRIGGER calc_total AFTER INSERT ON public.contracts FOR EACH ROW EXECUTE FUNCTION public.calc_total();
 -   DROP TRIGGER calc_total ON public.contracts;
       public          postgres    false    215    228            �           2606    16906 !   contracts contracts_sklad_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_sklad_id_fkey FOREIGN KEY (sklad_id) REFERENCES public.skladi(sklad_id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_sklad_id_fkey;
       public          postgres    false    210    215    3198            �           2606    16849    items items_owner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_owner_fkey FOREIGN KEY (owner) REFERENCES public.client(client_id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.items DROP CONSTRAINT items_owner_fkey;
       public          postgres    false    211    3201    213            �           2606    16839 *   skladi_client skladi_client_client_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.skladi_client
    ADD CONSTRAINT skladi_client_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(client_id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.skladi_client DROP CONSTRAINT skladi_client_client_id_fkey;
       public          postgres    false    211    3201    212            �           2606    16834 )   skladi_client skladi_client_sklad_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.skladi_client
    ADD CONSTRAINT skladi_client_sklad_id_fkey FOREIGN KEY (sklad_id) REFERENCES public.skladi(sklad_id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.skladi_client DROP CONSTRAINT skladi_client_sklad_id_fkey;
       public          postgres    false    210    212    3198            �           2606    16819    skladi skladi_owner_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.skladi
    ADD CONSTRAINT skladi_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.sklad_owner(owner_id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.skladi DROP CONSTRAINT skladi_owner_id_fkey;
       public          postgres    false    209    210    3196                   x������ � �            x������ � �      !      x������ � �            x������ � �      "      x�3375������ 
	�            x������ � �            x������ � �            x������ � �     