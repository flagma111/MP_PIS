
&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СписокНапоминанийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элемент.ТекущиеДанные;	
	СтруктураДляФормированияКлюча = Новый Структура("Ключ", ПолучитьКлюч(ТекущиеДанные.Элемент));
	ОткрытьФорму("РегистрСведений.Напоминания.Форма.ФормаЗаписи", СтруктураДляФормированияКлюча);
	ИндексТекущейСтроки = СписокНапоминаний.Индекс(ТекущиеДанные);
	СписокНапоминаний.Удалить(ИндексТекущейСтроки);
	Если СписокНапоминаний.Количество() = 0 Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере 
Функция ПолучитьКлюч(Элемент)
	Возврат РегистрыСведений.Напоминания.СоздатьКлючЗаписи(Новый Структура("Элемент", Элемент));
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокНапоминаний()
	СписокНапоминаний.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Напоминания.ДатаНапоминания КАК ДатаНапоминания,
	|	Напоминания.Элемент КАК Элемент,
	|	Напоминания.Комментарий КАК Комментарий,
	|	Напоминания.ВремяНапоминания КАК ВремяНапоминания,
	|	Напоминания.Периодичность КАК Периодичность
	|ИЗ
	|	РегистрСведений.Напоминания КАК Напоминания
	|ГДЕ
	|	Напоминания.ДатаНапоминания <= &ДатаНапоминания";	
	Запрос.УстановитьПараметр("ДатаНапоминания", ТекущаяДата());	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Нстр = СписокНапоминаний.добавить();
		Нстр.Напоминание = строка(Выборка.ДатаНапоминания) + " " + Выборка.Элемент + " " + Выборка.Комментарий; 
		ЗаполнитьЗначенияСвойств(Нстр,Выборка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаАктивизации(АктивныйОбъект, Источник)
	ЗаполнитьСписокНапоминаний();	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПерезаписьНапоминаний" Тогда
		ЗаполнитьСписокНапоминаний();
		Если СписокНапоминаний.Количество() = 0 Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСписокНапоминаний();	
КонецПроцедуры





