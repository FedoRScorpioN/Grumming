#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Основание")
		И ЗначениеЗаполнено(Параметры.Основание)
		И ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.ЗаписьКлиента") Тогда
		ДокументРТУ = Документы.ЗаписьКлиента.ПроверитьОказаниеУслуг(Параметры.Основание);
		
		Если ЗначениеЗаполнено(ДокументРТУ) Тогда
			СообщениеПользователю = Новый СообщениеПользователю();
			СообщениеПользователю.Текст = "Для документа уже введен документ реализации " + ДокументРТУ + "!";
			СообщениеПользователю.Сообщить();
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ПризнакОплаты = Перечисления.ОплатаДокумента.НеОплачен; 
	Иначе
		Если Объект.ПризнакОплаты <> Перечисления.ОплатаДокумента.ПолностьюОплачен Тогда
			СтруктураОплаты = Документы.РеализацияТоваровИУслуг.ПроверитьОплатуДокумента(Объект.Ссылка);
			Объект.ПризнакОплаты = СтруктураОплаты.ПризнакОплаты;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУслуги

&НаКлиенте
Процедура УслугиУслугаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
		СтрокаТЧ.Цена = РаботаСЦенами.ПолучитьЦенуПродажиНаДату(СтрокаТЧ.Номенклатура);
	Иначе
		СтрокаТЧ.Цена = 0;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыТоварПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
		СтрокаТЧ.Цена = РаботаСЦенами.ПолучитьЦенуПродажиНаДату(СтрокаТЧ.Номенклатура);
	Иначе
		СтрокаТЧ.Цена = 0;
	КонецЕсли;
	
	РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
КонецПроцедуры

#КонецОбласти