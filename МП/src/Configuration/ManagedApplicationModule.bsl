
Процедура ПриНачалеРаботыСистемы()
	#Если МобильноеПриложениеКлиент Тогда
		ДоставляемыеУведомления.ПодключитьОбработчикУведомлений("ПриПолученииуведомления");
	#КонецЕсли
	ПодключитьОбработчикОжидания("ПроверитьНапоминания", 300);
	ПодключитьОбработчикОжидания("ПерезаписатьНапоминания",60);
КонецПроцедуры

Процедура ПриПолученииУведомления(Уведомление,Локальное,Показано) экспорт
	ФормаНапоминаний = ПолучитьФорму("РегистрСведений.Напоминания.Форма.ФормаНапоминаний");
	текОкноН = НайтиОкноПоНавигационнойСсылке("Напоминания");
	если текОкноН = неопределено тогда
		ФормаНапоминаний.НавигационнаяСсылка = "Напоминания";
		ФормаНапоминаний.открыть();
	иначе
		ФормаНапоминаний.активизировать();
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьНапоминания() экспорт//Ден  2016 10 11 ---
	  Если ОбщийВызовСервера.ПроверитьНапоминанияСервер() Тогда
		  #Если МобильноеПриложениеКлиент Тогда
			  уведомление = новый ДоставляемоеУведомление;
			  уведомление.Текст = "Имеются просроченные уведомления";
			  уведомление.Заголовок = "Имеются просроченные уведомления";
			  уведомление.ДатаПоявленияУниверсальноеВремя = '00010101';
			  уведомление.ЗвуковоеОповещение = ЗвуковоеОповещение.ПоУмолчанию;
			  ДоставляемыеУведомления.ДобавитьЛокальноеУведомление(уведомление);
		  #КонецЕсли	  
	  КонецЕсли;
КонецПроцедуры

Процедура ПерезаписатьНапоминания() экспорт
	Если ОбщийВызовСервера.ПолучитьЗначениеКонстанты("ПерезаписатьНапоминания") = ложь Тогда
		возврат;
	КонецЕсли;
	попытка
		#Если МобильноеПриложениеКлиент Тогда
			//Сначала отменяем все уведомления
			ДоставляемыеУведомления.ОтменитьЛокальныеУведомления();
			//Получаем массив уведомлений
			МассивУведомлений = ОбщийВызовСервера.ПолучитьНапоминанияСервер();
			Если МассивУведомлений.количество() Тогда
				для каждого напоминание из МассивУведомлений цикл
					уведомление = новый ДоставляемоеУведомление;
					уведомление.Текст = строка(напоминание.элемент);
					уведомление.Заголовок = ?(напоминание.Комментарий = "",строка(напоминание.элемент),напоминание.Комментарий);
					уведомление.Данные = Строка(напоминание.элемент);
					уведомление.ДатаПоявленияУниверсальноеВремя = УниверсальноеВремя(напоминание.ДатаНапоминания);
					уведомление.ЗвуковоеОповещение = ЗвуковоеОповещение.ПоУмолчанию;
					//уведомление.ИнтервалПовтора = 120;
					ДоставляемыеУведомления.ДобавитьЛокальноеУведомление(уведомление);
				КонецЦикла;
			КонецЕсли;
		#КонецЕсли
	исключение
		сообщить("Ошибка при процедуре перезаписи напоминаний");
		сообщить(ОписаниеОшибки());
	КонецПопытки;
	ОбщийВызовСервера.ЗаписатьНовоеЗначениеКонстанты("ПерезаписатьНапоминания",ложь);	
КонецПроцедуры
