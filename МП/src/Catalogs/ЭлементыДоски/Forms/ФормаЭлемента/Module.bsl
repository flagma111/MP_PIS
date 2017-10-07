
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)//Ден  2016 10 11 ---
	Оповестить("Добавление элемента в раздел",объект.Владелец);	
КонецПроцедуры

&НаКлиенте
Процедура Напоминание(Команда)//Ден  2016 10 11 ---	
	Если Объект.Ссылка.Пустая() или Модифицированность Тогда
		попытка
			Записать();			
		исключение
			сообщить(ОписаниеОшибки());
			СоздаватьУведомление = ложь;
			возврат;
		КонецПопытки;
	КонецЕсли;
	
	ФормаНовогоНапоминания = ПолучитьФорму("РегистрСведений.Напоминания.ФормаЗаписи");
	ФормаНовогоНапоминания.Запись.Элемент = Объект.Ссылка;
	ФормаНовогоНапоминания.Запись.ДатаНапоминания = ТекущаяДата();
	ФормаНовогоНапоминания.Элементы.КнопкиОткладывания.Видимость = ложь;
	ФормаНовогоНапоминания.Открыть();
	закрыть();	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)//Ден  2016 10 12 ---
	Если объект.Ссылка.Пустая() Тогда
		элементы.Напоминания.Видимость = ложь;
		Возврат;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Напоминания.ДатаНапоминания КАК ДатаНапоминания
	|ИЗ
	|	РегистрСведений.Напоминания КАК Напоминания
	|ГДЕ
	|	Напоминания.Элемент = &Элемент";
	
	Запрос.УстановитьПараметр("Элемент", объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		элементы.ВремяНапоминания.Заголовок = строка(Выборка.ДатаНапоминания);
	иначе
		элементы.Напоминания.Видимость = ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПрикрепленныеФайлы.Представление), 0) КАК КоличествоФайлов
		|ИЗ
		|	РегистрСведений.ПрикрепленныеФайлы КАК ПрикрепленныеФайлы
		|ГДЕ
		|	ПрикрепленныеФайлы.Элемент = &Элемент";
	
	Запрос.УстановитьПараметр("Элемент", объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() и Выборка.КоличествоФайлов Тогда
		элементы.ПрикрепитьФайл.Заголовок = "Прикрепленные файлы(" + Выборка.КоличествоФайлов + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)//Ден  2016 10 14
	#Если МобильноеПриложениеКлиент Тогда
		Если объект.ссылка.Пустая() Тогда
			этаформа.ТекущийЭлемент = элементы.Наименование;
			НачатьРедактированиеЭлемента();
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ВремяНапоминанияНажатие(Элемент)//Ден  2016 10 21 ---
	ФормаСпискаНапоминаний = ПолучитьФорму("РегистрСведений.Напоминания.ФормаСписка");
	ЭлементОтбора = ФормаСпискаНапоминаний.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Элемент");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = объект.Ссылка;
	ФормаСпискаНапоминаний.открыть();
	закрыть();
КонецПроцедуры


&НаКлиенте
Процедура ПрикрепитьФайлНажатие(Элемент)//Ден  2016 11 05
	
	Если Объект.Ссылка.Пустая() или Модифицированность Тогда
		попытка
			Записать();			
		исключение
			сообщить(ОписаниеОшибки());
			ПрикреплятьФайл = ложь;
			возврат;
		КонецПопытки;
	КонецЕсли;
	
	Если элементы.ПрикрепитьФайл.Заголовок = "Прикрепить файл" Тогда
		ФормаФайла = ПолучитьФорму("РегистрСведений.ПрикрепленныеФайлы.ФормаЗаписи");
		ФормаФайла.запись.Элемент = объект.Ссылка;
		ФормаФайла.открыть();
		элементы.ПрикрепитьФайл.Заголовок = "Прикрепленные файлы";
	Иначе
		ФормаСпискаФайлов = ПолучитьФорму("РегистрСведений.ПрикрепленныеФайлы.ФормаСписка");
		ЭлементОтбора = ФормаСпискаФайлов.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Элемент");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = объект.Ссылка;
		ФормаСпискаФайлов.открыть();
		закрыть();
	КонецЕсли;

КонецПроцедуры

