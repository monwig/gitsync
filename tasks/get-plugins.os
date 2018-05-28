#Использовать gitrunner
#Использовать tempfiles

Перем Лог;

Процедура ПолучитьИсходники(Знач URLРепозитория, Знач Ветка, Знач Каталог)

	ГитРепозиторий = Новый ГитРепозиторий;

	ГитРепозиторий.УстановитьРабочийКаталог(Каталог);

	ГитРепозиторий.КлонироватьРепозиторий(URLРепозитория, Каталог);
	ГитРепозиторий.ПерейтиВВетку(Ветка);

КонецПроцедуры

Процедура СобратьПакет(Знач Каталог)
	
	Лог.Информация("Каталог сборки <%1>", Каталог);

	Лог.Информация("Сборка пакета библиотеки плагинов");
	// Лог.Информация(" - путь к файлу манифеста сборки пакета <%1>", ПутьКМанифестуСборки);
	КомандаOpm = Новый Команда;
	КомандаOpm.УстановитьРабочийКаталог(Каталог);
	КомандаOpm.УстановитьКоманду("opm");
	КомандаOpm.ДобавитьПараметр("build");	
	КомандаOpm.ДобавитьПараметр(Каталог);	

	КодВозврата = КомандаOpm.Исполнить();

	Если КодВозврата <> 0  Тогда
		ВызватьИсключение КомандаOpm.ПолучитьВывод();
	КонецЕсли;

	МассивФайлов = НайтиФайлы(Каталог, "*.ospx");

	Если МассивФайлов.Количество() = 0 Тогда
		ВызватьИсключение Новый ИнформацияОбОшибке("Ошибка создания пакета плагинов", "Не найден собранный файл плагина");
	КонецЕсли;

	ФайлПлагина = МассивФайлов[0].ПолноеИмя;

	КаталогПроекта = ОбъединитьПути(ТекущийСценарий().Каталог, "..", "embedded_plugins");
	
	ФайлПриемник = ОбъединитьПути(КаталогПроекта, МассивФайлов[0].Имя);

	КопироватьФайл(ФайлПлагина, ФайлПриемник);

КонецПроцедуры

Процедура ПолезнаяРабота()

	URLРепозитория = "https://github.com/khorevaa/gitsync3-plugins.git";
	КаталогСборки = ВременныеФайлы.СоздатьКаталог();
	Ветка = "master";

	ПолучитьИсходники(URLРепозитория, Ветка, КаталогСборки);
	СобратьПакет(КаталогСборки);

	ВременныеФайлы.УдалитьФайл(КаталогСборки);

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("task.install-opm");

ПолезнаяРабота();


