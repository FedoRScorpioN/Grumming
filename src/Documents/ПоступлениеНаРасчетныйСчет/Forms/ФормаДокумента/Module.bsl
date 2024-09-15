#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	ЭтоОплатаПобанковскимКартам = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияНаРасчетныйСчет.ОплатаПоБанковскимКартам"));
	ЭтоВзносНаличными = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияНаРасчетныйСчет.ВзносНаличными"));
	ЭтоОплатаОтПокупателя = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияНаРасчетныйСчет.ОплатаОтПокупателя"));
	ЭтоВозвратОтпоставщика = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияНаРасчетныйСчет.ВозвратОтПоставщика"));
	КонтрагентЯвляетсяПоставщиком = КонтрагентЯвляетсяПоставщиком(Объект.Плательщик); 
	
	Элементы.ЭквайринговыйТерминал.Видимость = ЭтоОплатаПобанковскимКартам;
	Элементы.Касса.Видимость = ЭтоВзносНаличными;
	Элементы.Плательщик.Видимость = ЭтоОплатаОтПокупателя ИЛИ ЭтоВозвратОтпоставщика; 
	Элементы.ДоговорКонтрагента.Видимость = (ЭтоОплатаОтПокупателя ИЛИ ЭтоВозвратОтпоставщика) И КонтрагентЯвляетсяПоставщиком;
КонецПроцедуры

&НаСервереБезКонтекста
Функция КонтрагентЯвляетсяПоставщиком(КонтрагентСсылка)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонтрагентСсылка", КонтрагентСсылка);
	Запрос.УстановитьПараметр("ТипКонтрагентаКлиент", Перечисления.ТипКонтрагента.Клиент);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Контрагент
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка = &КонтрагентСсылка
	|	И Контрагенты.ТипКонтрагента = &ТипКонтрагентаКлиент";
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой();
КонецФункции

#КонецОбласти