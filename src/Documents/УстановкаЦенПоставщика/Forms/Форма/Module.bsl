#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьПрайсЛист(Команда)
	СкопироватьФайлНаСервер("ПостроительЗапроса");
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СкопироватьФайлНаСервер(СпособЗагрузки)
	ОповещениеОЗавершении = Новый ОписаниеОповещения("СкопироватьФайлНаСерверЗавершение", ЭтотОбъект, СпособЗагрузки);
	НачатьПомещениеФайлаНаСервер(ОповещениеОЗавершении,,,,,УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьФайлНаСерверЗавершение(ОписаниеПомещенногоФайла, ДополнительныеПараметры) Экспорт
	Если ОписаниеПомещенногоФайла <> Неопределено Тогда
		АдресФайлаВХранилище = ОписаниеПомещенногоФайла.Адрес;
		ЗагрузитьИзТабличногоДокументаНаСервере(АдресФайлаВХранилище, ДатаПрайсЛиста, Поставщик, ДополнительныеПараметры);
		ОповеститьОбИзменении(Тип("ДокументСсылка.УстановкаЦенПоставщика"));
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗагрузитьИзТабличногоДокументаНаСервере(АдресФайлаВХранилище, ДатаПрайсЛиста, Поставщик, ДополнительныеПараметры)
	ТабДок = ПрочитатьФайл(АдресФайлаВХранилище);
	ТаблицаПрайсЛиста  = ЗаполнитьТаблицуЗначенийЧерезПостроительЗапроса(ТабДок);
	
	Если ТаблицаПрайсЛиста.Количество() Тогда
		ЗагрузитьПрайсЛистПоставщика(ТаблицаПрайсЛиста, ДатаПрайсЛиста, Поставщик);
	Иначе
		СообщениеПользователю = Новый СообщениеПользователю();
		СообщениеПользователю.Текст = "Выбранный файл не содержит строк с ценами!";
		СообщениеПользователю.Сообщить();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьФайл(АдресФайлаВХранилище)
	ТабДок = Новый ТабличныйДокумент;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".xlsx");
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	Попытка
		ТабДок.Прочитать(ИмяВременногоФайла);
	Исключение  
		вызватьИсключение "Не удалось прочитать файл EXCEL в табличный документ!";
	КонецПопытки; 
	
	Возврат ТабДок;
КонецФункции

&НаСервереБезКонтекста
Процедура ЗагрузитьПрайсЛистПоставщика(ТаблицаПрайсЛиста, ДатаПрайсЛиста, Поставщик)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаПрайсЛиста", ТаблицаПрайсЛиста);
	
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ТаблицаПрайсЛиста.Артикул КАК Артикул,
	|	ТаблицаПрайсЛиста.Цена КАК Цена
	|ПОМЕСТИТЬ ВТ_ТаблицаПрайсЛиста
	|ИЗ
	|	&ТаблицаПрайсЛиста КАК ТаблицаПрайсЛиста
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Ном.Ссылка КАК Номенклатура,
	|	ВТ_ТаблицаПрайсЛиста.Цена КАК Цена
	|ИЗ
	|	ВТ_ТаблицаПрайсЛиста КАК ВТ_ТаблицаПрайсЛиста
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Ном
	|		ПО ВТ_ТаблицаПрайсЛиста.Артикул = Ном.Артикул";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	ДокументУстановкиЦен = Документы.УстановкаЦенПоставщика.СоздатьДокумент();
	ДокументУстановкиЦен.Контрагент = Поставщик;
	ДокументУстановкиЦен.Дата = ДатаПрайсЛиста;
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрокаПрайса = ДокументУстановкиЦен.Товары.Добавить();
		НоваяСтрокаПрайса.Номенклатура = Выборка.Номенклатура;
		НоваяСтрокаПрайса.Цена = Выборка.Цена;
	КонецЦикла;
	
	Попытка
		
		ДокументУстановкиЦен.Записать(РежимЗаписиДокумента.Проведение);
		
		СообщениеПользователю = Новый СообщениеПользователю();
		//Сообщение сделал чуть более читаемое, чем в примере ТЗ, без задвоения названия
		СообщениеПользователю.Текст = СтрШаблон("Создан и проведен документ %1", ДокументУстановкиЦен);
		СообщениеПользователю.Сообщить();
		
	Исключение
		ДокументУстановкиЦен.Записать();
		
		СообщениеПользователю = Новый СообщениеПользователю();
		СообщениеПользователю.Текст = "Произошла ошибка при проведении документа установки цен!";
		СообщениеПользователю.Сообщить();
		
	КонецПопытки;
Конецпроцедуры

&НаСервереБезКонтекста
Функция ЗаполнитьТаблицуЗначенийЧерезПостроительЗапроса(ТабДок)
	ОбластиТабличногоДокумента = ТабДок.Область(1, 1, ТабДок.ВысотаТаблицы, ТабДок.ШиринаТаблицы);
	
	Построитель = Новый ПостроительЗапроса;
	Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ОбластиТабличногоДокумента);
	Построитель.Выполнить();
	
	ТаблицаПрайсЛиста = Построитель.Результат.Выгрузить();
	
	Возврат ТаблицаПрайсЛиста;
КонецФункции

#КонецОбласти