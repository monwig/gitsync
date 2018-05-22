﻿перем Лог;

Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("u storage-user", "", "пользователь хранилища конфигурации").ТСтрока().ВОкружении("GITSYNC_STORAGE_USER").ПоУмолчанию("Администратор");
	Команда.Опция("p storage-pwd", "", "пароль пользователя хранилища конфигурации").ТСтрока().ВОкружении("GITSYNC_STORAGE_PASSWORD GITSYNC_STORAGE_PWD");

	Команда.Аргумент("PATH", "", "Путь к хранилищу конфигурации 1С.").ТСтрока().ВОкружении("GITSYNC_STORAGE_PATH");
	Команда.Аргумент("URL", "", "Адрес удаленного репозитория GIT.").ТСтрока().ВОкружении("GITSYNC_REPO_URL");
	Команда.Аргумент("WORKDIR", "", "Каталог исходников внутри локальной копии git-репозитария.").ТСтрока().ВОкружении("GITSYNC_WORKDIR").Обязательный(Ложь).ПоУмолчанию(ТекущийКаталог());

	// Команда.УстановитьДействиеПередВыполнением(ПараметрыПриложения);
	Команда.УстановитьДействиеПослеВыполнения(ПараметрыПриложения);

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ПутьКХранилищу			= Команда.ЗначениеАргумента("PATH");
	КаталогРабочейКопии		= Команда.ЗначениеАргумента("WORKDIR");
	URLРепозитория			= Команда.ЗначениеАргумента("URL");

	ПользовательХранилища		= Команда.ЗначениеОпции("--storage-user");
	ПарольПользователяХранилища	= Команда.ЗначениеОпции("--storage-pwd");

	ФайлЛокальныйКаталогГит = Новый Файл(КаталогРабочейКопии);
	КаталогРабочейКопии = ФайлЛокальныйКаталогГит.ПолноеИмя;
	Лог.Отладка("КаталогРабочейКопии: %1", КаталогРабочейКопии);

	Если ПустаяСтрока(URLРепозитория) Тогда

		ВызватьИсключение "Не указан URL репозитария";

	КонецЕсли;

	КлонироватьРепозитарий(КаталогРабочейКопии, URLРепозитория);

	ФайлКаталогРабочейКопии = Новый Файл(КаталогРабочейКопии);
	Если Не ФайлКаталогРабочейКопии.Существует() Тогда
		СоздатьКаталог(КаталогРабочейКопии);
	КонецЕсли;
	
	МассивФайлов = НайтиФайлы(КаталогРабочейКопии, "src");
	КаталогИсходников = КаталогРабочейКопии;
	Если МассивФайлов.Количество() > 0  Тогда
		КаталогИсходников = МассивФайлов[0].ПолноеИмя;
	КонецЕсли;
	
	ОбщиеПараметры = ПараметрыПриложения.Параметры();
	МенеджерПлагинов = ОбщиеПараметры.УправлениеПлагинами;
	
	ОбработчикПодписок = МенеджерПлагинов.НовыйМенеджерПодписок();

	Распаковщик = Новый МенеджерСинхронизации();
	Распаковщик.ВерсияПлатформы(ОбщиеПараметры.ВерсияПлатформы)
			   .ПодпискиНаСобытия(ОбработчикПодписок)
			//    .УровеньЛога(ОбщиеПараметры.УровеньЛога) // Пока нет данной опции
			   .АвторизацияВХранилищеКонфигурации(ПользовательХранилища, ПарольПользователяХранилища);

	Распаковщик.НаполнитьКаталогРабочейКопииСлужебнымиДанными(КаталогИсходников, ПутьКХранилищу);

	Лог.Информация("Клонирование завершено");

КонецПроцедуры // ВыполнитьКоманду

// Выполняет клонирование удаленного репо
//
Функция КлонироватьРепозитарий(Знач КаталогЛокальнойКопии, Знач URLРепозитария) Экспорт
	
	ГитРепозиторий = Новый ГитРепозиторий;
	ГитРепозиторий.УстановитьРабочийКаталог(КаталогЛокальнойКопии);
	ГитРепозиторий.КлонироватьРепозиторий(URLРепозитария, КаталогЛокальнойКопии);

КонецФункции

Лог = ПараметрыПриложения.Лог();