﻿#Использовать logos

Перем Лог;

Процедура ВыполнитьКоманду(Знач КомандаЗапуска, Знач ТекстОшибки = "")

	Лог.Информация("Выполняю команду: " + КомандаЗапуска);

	Процесс = СоздатьПроцесс(КомандаЗапуска, ТекущийКаталог(), Истина, , КодировкаТекста.UTF8);
	Процесс.Запустить();

	Процесс.ОжидатьЗавершения();

	Пока НЕ Процесс.Завершен Цикл
		Пока Процесс.ПотокВывода.ЕстьДанные Цикл
			СтрокаВывода = Процесс.ПотокВывода.ПрочитатьСтроку();
			Сообщить(СтрокаВывода);
		КонецЦикла;
	КонецЦикла;

	Если Процесс.КодВозврата <> 0 Тогда
		Лог.Ошибка("Код возврата: " + Процесс.КодВозврата);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.app.1c-syntax");
Лог.УстановитьУровень(УровниЛога.Информация);

ПутьКБинарникамНод = ОбъединитьПути("node_modules", "bin");
ПутьКБинарникамНод = ПутьКБинарникамНод + ПолучитьРазделительПути();

КомандаЗапуска = "npm -v";
ВыполнитьКоманду(КомандаЗапуска, "Ошибка проверки версии npm");

КомандаЗапуска = "npm install";
ВыполнитьКоманду(КомандаЗапуска, "Ошибка установки пакетов node.js");

КомандаЗапуска = ПутьКБинарникамНод + "yaml2json 1c.YAML-tmLanguage > 1c.json";
ВыполнитьКоманду(КомандаЗапуска, "Ошибка компиляции YAML -> JSON");

КомандаЗапуска = ПутьКБинарникамНод + "json2cson 1c.json > 1c.cson";
ВыполнитьКоманду(КомандаЗапуска, "Ошибка компиляции JSON -> CSON");

ИмяВременногоФайла = ПолучитьИмяВременногоФайла("js");
ЗаписьТекста = Новый ЗаписьТекста(ИмяВременногоФайла);

ТекстСкрипта =
"var plist = require('plist');
|var fs = require('fs');
|
|var jsonString = fs.readFileSync('1c.json', 'utf8');
|var jsonObject = JSON.parse(jsonString);
|var plistString = plist.build(jsonObject);
|
|fs.writeFileSync('1c.tmLanguage', plistString);";

ЗаписьТекста.Записать(ТекстСкрипта);

КомандаЗапуска = "node " + ИмяВременногоФайла;
ВыполнитьКоманду(КомандаЗапуска, "Ошибка компиляции JSON -> tmLanguage");

УдалитьФайлы(ИмяВременногоФайла);
