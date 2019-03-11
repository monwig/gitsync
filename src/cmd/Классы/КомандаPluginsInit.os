
Перем Лог;

Процедура ОписаниеКоманды(Команда) Экспорт

	Лог.Отладка("Пустое заполнение команды <plugins init>");

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	КаталогПриложения  = ПараметрыПриложения.КаталогПриложения();

	КаталогВстроенныхПлагинов = ОбъединитьПути(КаталогПриложения, "embedded_plugins");

	МассивФайловПлагинов = НайтиФайлы(КаталогВстроенныхПлагинов, "*.ospx");

	ОбщиеПараметры = ПараметрыПриложения.Параметры();
	МенеджерПлагинов = ОбщиеПараметры.УправлениеПлагинами;

	Лог.Информация("Начата инициализация предустановленных плагинов");
	Лог.Отладка("Каталог поиска предустановленных плагинов: <%1>", КаталогВстроенныхПлагинов);
	Лог.Отладка("Количество пакетов плагинов к установке: <%1>", МассивФайловПлагинов.Количество());

	Для каждого ФайлПакетаПлагинов Из МассивФайловПлагинов Цикл

		Лог.Отладка("Устанавливаю пакет плагинов из файла: <%1>", ФайлПакетаПлагинов.ПолноеИмя);
		МенеджерПлагинов.УстановитьФайлПлагин(ФайлПакетаПлагинов.ПолноеИмя);

	КонецЦикла;

	Лог.Информация("Инициализация предустановленных плагинов завершена");

КонецПроцедуры

Лог = ПараметрыПриложения.Лог();