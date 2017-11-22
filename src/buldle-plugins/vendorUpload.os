
#Использовать logos

Перем ВерсияПлагина;
Перем Лог;
Перем КомандыПлагина;
Перем МассивНомеровВерсий;
Перем мАвторизацияВХранилищеСредствами1С;
Перем Обработчик;


Функция Информация() Экспорт
	
	Возврат Новый Структура("Версия, Лог", ВерсияПлагина, Лог)
	
КонецФункции // Информация() Экспорт

Процедура ПриАктивизацииПлагина(СтандартныйОбработчик) Экспорт
	
	Обработчик = СтандартныйОбработчик;

КонецПроцедуры

Процедура ПриРегистрацииКомандыПриложения(ИмяКоманды, КлассРеализации, Парсер) Экспорт

	Лог.Отладка("Ищю команду <%1> в списке поддерживаемых", ИмяКоманды);
	Если КомандыПлагина.Найти(ИмяКоманды) = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Лог.Отладка("Устанавливаю дополнительные параметры для команды %1", ИмяКоманды);
	
	ОписаниеКоманды = Парсер.ПолучитьКоманду(ИмяКоманды);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды,"--storage-user", СтрШаблон("[PLUGIN] [%1] <пользователь хранилища конфигурации", ИмяПлагина()));
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды,"--storage-pwd", СтрШаблон("[PLUGIN] [%1] <пароль пользователя хранилища конфигурации>", ИмяПлагина()));	

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

Процедура ПриВыполненииКоманды(ПараметрыКоманды, ДополнительныеПараметры) Экспорт
	
	УстановитьАвторизациюВХранилищеКонфигурации(ПараметрыКоманды["--storage-user"], ПараметрыКоманды["--storage-pwd"]);
	ПроверитьПараметрыДоступаКХранилищу();

КонецПроцедуры


// Выполняет штатную выгрузку конфигурации в файлы (средствами платформы 8.3) без загрузки конфигурации, но с обновлением на версию хранилища
//
Процедура ПриЗагрузкеВерсииХранилищаВКонфигурацию(Конфигуратор, КаталогРабочейКопии, ПутьКХранилищу, НомерВерсии, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
		
	ПользовательХранилища = мАвторизацияВХранилищеСредствами1С.ПользовательХранилища;
	ПарольХранилища		  = мАвторизацияВХранилищеСредствами1С.ПарольХранилища;

	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/ConfigurationRepositoryUpdateCfg");
	ПараметрыЗапуска.Добавить("/ConfigurationRepositoryF """+ПутьКХранилищу+"""");
	
	ПараметрыЗапуска.Добавить("/ConfigurationRepositoryN """+ПользовательХранилища+"""");
	
	Если Не ПустаяСтрока(ПарольХранилища) Тогда
		ПараметрыЗапуска.Добавить("/ConfigurationRepositoryP """+ПарольХранилища+"""");
	КонецЕсли;

	ПараметрыЗапуска.Добавить("-v "+НомерВерсии);
	
	ПараметрыЗапуска.Добавить("-force");
	
	Попытка
		Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);
	Исключение

		ТекстОшибки = Конфигуратор.ВыводКоманды();
		ВызватьИсключение ТекстОшибки;

	КонецПопытки;

КонецПроцедуры

// Устанавливает параметры авторизации в хранилище 1С, если выгрузка версии выполняется средствами платформы
//
Процедура УстановитьАвторизациюВХранилищеКонфигурации(Знач Логин, Знач Пароль)
	
	мАвторизацияВХранилищеСредствами1С = Новый Структура;
	мАвторизацияВХранилищеСредствами1С.Вставить("ПользовательХранилища" , Логин);
	мАвторизацияВХранилищеСредствами1С.Вставить("ПарольХранилища", Пароль);

КонецПроцедуры

Процедура ПроверитьПараметрыДоступаКХранилищу() Экспорт
	
	Если мАвторизацияВХранилищеСредствами1С.ПользовательХранилища = Неопределено Тогда
		
		ВызватьИсключение "Не задан пользователь хранилища конфигурации.";
		
	КонецЕсли;
	
	Если мАвторизацияВХранилищеСредствами1С.ПарольХранилища = Неопределено Тогда
	
		ПарольХранилища = "";
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьПараметрыДоступаКХранилищу


Функция Форматировать(Знач Уровень, Знач Сообщение) Экспорт
	
	Возврат СтрШаблон("[PLUGIN] %1: %2 - %3", ИмяПлагина(), УровниЛога.НаименованиеУровня(Уровень), Сообщение);
	
КонецФункции


Функция ИмяПлагина()
	возврат "vendorUpload";
КонецФункции // ИмяПлагина()

Процедура Инициализация()

	ВерсияПлагина = "1.0.0";
	Лог = Логирование.ПолучитьЛог("oscript.app.gitsync.plugins."+ ИмяПлагина());
	КомандыПлагина = Новый Массив;
	КомандыПлагина.Добавить("sync");
	КомандыПлагина.Добавить("export");
	мАвторизацияВХранилищеСредствами1С = Новый Структура("ПользовательХранилища, ПарольХранилища");

	Лог.УстановитьРаскладку(ЭтотОбъект);

КонецПроцедуры

Инициализация();


