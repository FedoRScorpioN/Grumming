Перем обОтладкаВнешнегоЗапроса Экспорт; //флаг того, что запросник открыт для отладки внешнего запроса
Перем обТекущийЗапрос Экспорт; //текущий запрос
Перем обИмяВременногоФайла Экспорт; //имя файла для временного сохранения запросов
Перем обПредставлениеВременногоФайла Экспорт; //имя файла для временного сохранения запросов
Перем обРежимВнешнейОбработки Экспорт;//запросник открыт в режиме внешней обработки
Перем КэшСконвертированныхОбъектов;
Процедура обПоказатьЗначение(СодержимоеЯчейки,ИмяДанных) Экспорт

	Если ТипЗнч(СодержимоеЯчейки) = Тип("ТаблицаЗначений") Тогда
		обПоказатьТаблицуЗначений(СодержимоеЯчейки);
	ИначеЕсли ТипЗнч(СодержимоеЯчейки) = Тип("РезультатЗапроса") Тогда
		обПоказатьТаблицуЗначений(СодержимоеЯчейки.Выгрузить(ОбходРезультатаЗапроса.Прямой));
	ИначеЕсли ТипЗнч(СодержимоеЯчейки) = Тип("МоментВремени") Тогда
		#Если Клиент Тогда
			Предупреждение(СокрЛП(СодержимоеЯчейки.Дата)+ " ; " +СокрЛП(СодержимоеЯчейки.Ссылка),,"Момент времени:");
		#КонецЕсли
	ИначеЕсли ТипЗнч(СодержимоеЯчейки) = Тип("ХранилищеЗначения") Тогда
		Значение = СодержимоеЯчейки.Получить();
		Если Значение <> Неопределено Тогда
			Форма = ПолучитьФорму("ФормаОтображенияДанных");
			Форма.Данные = Значение;
			Форма.ДанныеИмя = ИмяДанных;
			Форма.Открыть();
		КонецЕсли;
	Иначе
		#Если Клиент Тогда
			ОткрытьЗначение(СодержимоеЯчейки);
		#КонецЕсли
	КонецЕсли;

КонецПроцедуры //обПоказатьЗначение

//показывает содержимое таблицы значений в отдельной форме
//при модальном открытии возвращает таблицу значений из формы
Функция обПоказатьТаблицуЗначений(Знач ТЗначений, Модально = Ложь) Экспорт

	ФормаПоказа = ПолучитьФорму("ТаблицаЗначений");
	ФормаПоказа.ТаблицаЗначений = ?(ТЗначений = Неопределено, Новый ТаблицаЗначений, ТЗначений.Скопировать());
	
	Если Модально Тогда
		ТЗВозврата = ФормаПоказа.ОткрытьМодально();
		Возврат ТЗВозврата;
	Иначе	
		ФормаПоказа.Открыть();
	КонецЕсли; 

КонецФункции//обПоказатьТаблицуЗначений

//удаляет из текста запроса всю шнягу которая там при переносе из модуля 
//(палки, кавычки, точки с запятой)
Функция обПропылесоситьТекстЗапроса(ИсходныйТекст) Экспорт
	
    ИсходныйТекст = СокрЛП(ИсходныйТекст);
	
	//вертипалки
    ОбработанныйТекст	=	СтрЗаменить(ИсходныйТекст,"|","");
	
	//открывающая кавычка
	Пока Лев(ОбработанныйТекст,1) = Символ(34) Цикл
		ОбработанныйТекст = Сред(ОбработанныйТекст,2);
		//закрывающая кавычка удаляется только если была открывающая
		//иначе может быть глюк со строковым выражением в запросе
		Пока Прав(ОбработанныйТекст,1) = Символ(34) Цикл
			ОбработанныйТекст = Сред(ОбработанныйТекст,1,СтрДлина(ОбработанныйТекст)-1);
		КонецЦикла; 
	КонецЦикла; 
	//закрывающая точка с запятой
	Если Прав(ОбработанныйТекст,1) = ";" Тогда
	    ОбработанныйТекст = Сред(ОбработанныйТекст,1,СтрДлина(ОбработанныйТекст)-1);
	КонецЕсли; 
	
	//двойные кавычки надо заменить на одинарные
	//Строка2Кавычки = Символ(34) + Символ(34);
	//Строка1Кавычка = Символ(34);
	
    //ОбработанныйТекст	=	СтрЗаменить(ОбработанныйТекст,Строка2Кавычки,Строка1Кавычка);
	
	Возврат ОбработанныйТекст;

КонецФункции //обПропылесоситьТекстЗапроса
 
//загружает внешний запрос в строку дерева запросов
//
Функция обПолучитьВнешнийЗапрос(СтрокаДереваЗапросов) Экспорт

	СтрокаДереваЗапросов.ТекстЗапроса = обТекущийЗапрос.Текст;
	
	Для каждого ПараметрЗапроса Из обТекущийЗапрос.Параметры Цикл
		
		НовПараметр = СтрокаДереваЗапросов.ПараметрыЗапроса.Добавить();
		НовПараметр.ИмяПараметра = ПараметрЗапроса.Ключ;
		НовПараметр.ЭтоВыражение = Ложь;
		
		Если ТипЗнч(ПараметрЗапроса.Значение) = Тип("Массив") Тогда
			//массив преобразуем в список, чтобы можно было смотреть/править интерактивно
			Список = Новый СписокЗначений;
			Список.ЗагрузитьЗначения(ПараметрЗапроса.Значение);
			НовПараметр.ЗначениеПараметра = Список;
		ИначеЕсли ТипЗнч(ПараметрЗапроса.Значение) = Тип("МоментВремени") Тогда	
			
			НовПараметр.МоментВремениДата = ПараметрЗапроса.Значение.Дата;
			НовПараметр.МоментВремениСсылка = ПараметрЗапроса.Значение.Ссылка;	
			
			НовПараметр.ЗначениеПараметра = "Момент времени: " + СокрЛП(НовПараметр.МоментВремениСсылка) + ", дата: " + СокрЛП(НовПараметр.МоментВремениДата);
			
		ИначеЕсли ТипЗнч(ПараметрЗапроса.Значение) = Тип("Граница") Тогда	
			
			НовПараметр.ГраницаЗначение = ПараметрЗапроса.Значение.Значение;
			НовПараметр.ГраницаВид = ПараметрЗапроса.Значение.ВидГраницы;	
			
			НовПараметр.ЗначениеПараметра = "Граница: "+ СокрЛП(НовПараметр.ГраницаЗначение) + ",  " + СокрЛП(НовПараметр.ГраницаВид);
			
		ИначеЕсли ТипЗнч(ПараметрЗапроса.Значение) = Тип("ТаблицаЗначений") Тогда	
			
			НовПараметр.ЗначениеПараметра = "<ТаблицаЗначений> : " + СокрЛП(ПараметрЗапроса.Значение.Количество()) + " стр.";
			НовПараметр.ТаблицаЗначений = ПараметрЗапроса.Значение;	

		Иначе
			НовПараметр.ЗначениеПараметра = ПараметрЗапроса.Значение;	
		КонецЕсли;//  
		
	КонецЦикла; 
	
	СтрокаДереваЗапросов.Запрос = "Отладка";
	СтрокаДереваЗапросов.СпособВыгрузки = 1;
	СтрокаДереваЗапросов.СпособВыборки = 1;     
	СтрокаДереваЗапросов.ОбходитьИерархическиеВыборкиРекурсивно = Истина;     

КонецФункции //обПолучитьВнешнийЗапрос
 
//оформление строки результата запроса
//
Процедура обОформитьСтрокуТаблицыРезультата(ОформлениеСтроки) Экспорт

	Для каждого Ячейка Из ОформлениеСтроки.Ячейки Цикл
		Если Ячейка.Значение = NULL Тогда
			Ячейка.Текст = "<NULL>";
			Ячейка.ЦветТекста = WebЦвета.Серый;
		ИначеЕсли Ячейка.Значение = Неопределено Тогда	
			Ячейка.Текст = "<Неопределено>";
			Ячейка.ЦветТекста = WebЦвета.Серый;
		ИначеЕсли ТипЗнч(Ячейка.Значение) = Тип("МоментВремени") Тогда	
			Ячейка.Текст = "<МоментВремени>";
			Ячейка.ЦветТекста = WebЦвета.Серый;
		ИначеЕсли ТипЗнч(Ячейка.Значение) = Тип("РезультатЗапроса") Тогда	
			Ячейка.Текст = "<РезультатЗапроса>";
			Ячейка.ЦветТекста = WebЦвета.Серый;
		ИначеЕсли  Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(Ячейка.Значение)) 
			ИЛИ Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Ячейка.Значение)) 
			ИЛИ ПланыСчетов.ТипВсеСсылки().СодержитТип(ТипЗнч(Ячейка.Значение)) 
			ИЛИ ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(ТипЗнч(Ячейка.Значение))
			ИЛИ ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(ТипЗнч(Ячейка.Значение))
			ИЛИ Перечисления.ТипВсеСсылки().СодержитТип(ТипЗнч(Ячейка.Значение))
			Тогда
			Если Ячейка.Значение.Пустая() Тогда	    
				Ячейка.Текст = "<пустая ссылка " + ТипЗнч(Ячейка.Значение) + ">";
				Ячейка.ЦветТекста = WebЦвета.Серый;
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла; 

КонецПроцедуры //обОформитьСтрокуТаблицыРезультата
 
//загружает внешний запрос в строку дерева запросов для отладки и открывает форму Запросника
//
Функция ОтладитьЗапрос(Запрос, Знач Модально = Ложь,НовыйСеанс = Ложь) Экспорт
    	
	обТекущийЗапрос = Запрос;
	обОтладкаВнешнегоЗапроса = Истина;
	//Если НовыйСеанс Тогда
	//	Connection = Истина;                                                                                  
	//	мТекущееПодключение = Новый COMОбъект("V82.Application");
	//	ТекущаяСтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	//	//Добавим имя пользователя и сбросим пароль для подключения
	//	ТекПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	//	ХэшПароля = ТекПользователь.СохраняемоеЗначениеПароля;
	//	ТекПользователь.Пароль = "";
	//	ТекущаяСтрокаСоединения = ТекущаяСтрокаСоединения + "Usr="""+ТекПользователь.Имя+""";";
	//	
	//	//установим режим запуска - обычное приложение
	//	СтарыйРежим = ТекПользователь.РежимЗапуска;
	//	ТекПользователь.РежимЗапуска = РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение;
	//	
	//	Попытка
	//		ТекПользователь.Записать();
	//		Connection = мТекущееПодключение.Connect(ТекущаяСтрокаСоединения);
	//		ТекПользователь.СохраняемоеЗначениеПароля = ХэшПароля;
	//		ТекПользователь.РежимЗапуска = СтарыйРежим;
	//		ТекПользователь.Записать();
	//	Исключение
	//		//вернем пароль в случае неудачи
	//		ТекПользователь.СохраняемоеЗначениеПароля = ХэшПароля;
	//		ТекПользователь.РежимЗапуска = СтарыйРежим;
	//		ТекПользователь.Записать();
	//	КонецПопытки;
	//	мТекущееПодключение.Visible = True;
	//	ОбработкаВОЛЕ = мТекущееПодключение.ВнешниеОбработки.Создать(ИспользуемоеИмяФайла);
	//	ЗапросВДругойБазе = КонвертироватьЗапрос(Запрос,мТекущееПодключение,ОбработкаВОЛЕ);
	//	ОбработкаВОЛЕ.ОтладитьЗапрос(ЗапросВДругойБазе);
	//	ОбработкаВОЛЕ = Неопределено;
	//	ЗапросВДругойБазе = Неопределено;
	//	мТекущееПодключение = Неопределено;
	//	
	//	Возврат Истина;

	//КонецЕсли;
	
	Если Модально Тогда
		ПолучитьФорму("Форма").ОткрытьМодально();	
	Иначе	
		ПолучитьФорму("Форма").Открыть();	
	КонецЕсли; 

КонецФункции //Отладить
//Создаём такой же запрос в другой базе
Функция КонвертироватьЗапрос(ЗапросИсточник,Подключение,ОбработкаВОЛЕ)
	ЗапросПриёмник = Подключение.NewObject("Query");
	ЗапросПриёмник.Текст = ЗапросИсточник.Текст;
	Для Каждого ПараметрЗапроса Из ЗапросИсточник.Параметры Цикл
		КлючПараметра = ПараметрЗапроса.Ключ;
		
		ЗапросПриёмник.Параметры.Вставить(КлючПараметра,СконвертироватьОбъект(ПараметрЗапроса.Значение,Подключение,ОбработкаВОЛЕ));
		
	КонецЦикла;
	
	ЗапросПриёмник.МенеджерВременныхТаблиц = ПопытатьсяСоздатьМенеджерВТ(ЗапросИсточник,Подключение,ОбработкаВОЛЕ);
	Возврат ЗапросПриёмник;
КонецФункции // КонвертироватьЗапрос()

Функция ПопытатьсяСоздатьМенеджерВТ(ЗапросИсточник,Подключение,ОбработкаВОЛЕ) Экспорт
	Если ЗапросИсточник.МенеджерВременныхТаблиц = Неопределено Тогда
		Возврат Неопределено
	КонецЕсли;
	МенеджерВТ = Подключение.NewObject("МенеджерВременныхТаблиц");
	//Получить все источники данных
	ВременныйТекстЗапроса = Врег(ЗапросИсточник.Текст);
	МассивКлючевыхСлов = Новый Массив;
	МассивКлючевыхСлов.Добавить("ИЗ");
	МассивКлючевыхСлов.Добавить("СОЕДИНЕНИЕ");
		Для Каждого КлючевоеСлово Из МассивКлючевыхСлов Цикл
		Для ВариантПрефикса = 1 по 2 Цикл
			ТекКлючСлово = КлючевоеСлово;
			Если ВариантПрефикса=1 Тогда
				ТекКлючСлово = Символы.ПС + ТекКлючСлово;
			Иначе
				ТекКлючСлово = " " + ТекКлючСлово;
			КонецЕсли;
			Для ВариантПостфикcа = 1 по 2 Цикл
				СловоСПрефиксом = ТекКлючСлово;
				Если ВариантПостфикcа = 1 Тогда
					ОкончательноеСлово = СловоСПрефиксом+" ";
				Иначе
					ОкончательноеСлово = СловоСПрефиксом+Символы.ПС;
				КонецЕсли;
				ВременныйТекстЗапроса = ЗапросИсточник.Текст;
				ЧислоСекций = СтрЧислоВхождений(ЗапросИсточник.Текст,ОкончательноеСлово);
				Для Сч = 1 По ЧислоСекций Цикл
					ВременныйТекстЗапроса = Сред(ВременныйТекстЗапроса,Найти(ВременныйТекстЗапроса,ОкончательноеСлово)+СтрДлина(ОкончательноеСлово),СтрДлина(ВременныйТекстЗапроса));
					ВременныйТекстЗапроса = СокрЛП(ВременныйТекстЗапроса);
					СократитьДоЗначимогоСимвола(ВременныйТекстЗапроса);
					//Следующий пробел или перевод строки
					Пробел = Найти(ВременныйТекстЗапроса," ");
					Перевод = Найти(ВременныйТекстЗапроса,Символы.ПС);
					ТекГраницаНазвания = 999;
					Если Пробел<>0 Тогда
						ТекГраницаНазвания = Пробел;
					КонецЕсли;
					Если Перевод<>0 и ТекГраницаНазвания>Перевод Тогда
						ТекГраницаНазвания = Перевод;
					КонецЕсли;
					НазваниеИсточника = Лев(ВременныйТекстЗапроса,ТекГраницаНазвания-1);
					Если НазваниеИсточника="" Тогда
						Продолжить;
					КонецЕсли;
					Если Лев(НазваниеИсточника,1)="&" или Лев(НазваниеИсточника,1)="(" Тогда
						//ЭтоВТ или временнаятаблица
						Продолжить;
					ИначеЕсли Найти(НазваниеИсточника,".")>0 Тогда
						// это системные таблицы
						Продолжить;
					КонецЕсли;
					ЗапросПолученияДанныхВТ = Новый Запрос;
					ЗапросПолученияДанныхВТ.МенеджерВременныхТаблиц = ЗапросИсточник.МенеджерВременныхТаблиц;
					ЗапросПолученияДанныхВТ.Текст = "Выбрать * Из "+НазваниеИсточника;
					ТЗВременнойТаблицы = ЗапросПолученияДанныхВТ.Выполнить().Выгрузить();
					ЗапросВПриемнике = Подключение.NewObject("Query");
					ЗапросВПриемнике.Текст = "Выбрать * Поместить "+НазваниеИсточника+" Из &ТаблицаЗначений ТЗ";
					ЗапросВПриемнике.МенеджерВременныхТаблиц = МенеджерВТ;
					ЗапросВПриемнике.УстановитьПараметр("ТаблицаЗначений",СконвертироватьОбъект(ТЗВременнойТаблицы,Подключение,ОбработкаВОЛЕ));
					ЗапросВПриемнике.Выполнить();
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
    Возврат МенеджерВТ;
КонецФункции // ПопытатьсяСоздатьМенеджерВТ()

Процедура СократитьДоЗначимогоСимвола(ТекстЗапроса)
	Пока Истина Цикл
 		ТекСимвол = Лев(ТекстЗапроса,1);
		Если ТекСимвол="" Тогда
			Возврат;
		ИначеЕсли ТекСимвол = " " 
			Или ТекСимвол = Символы.ПС Тогда
			ТекстЗапроса = Сред(ТекстЗапроса,2,СтрДлина(ТекстЗапроса));
		Иначе
			Возврат;
		КонецЕсли;
 	КонецЦикла;
	

КонецПроцедуры // СократитьДоЗначимогоСимвола()


Функция СконвертироватьОбъект(ЗначениеИсточника,Подключение,ОбработкаВОЛЕ)
	Если КэшСконвертированныхОбъектов.Получить(ЗначениеИсточника)<>Неопределено Тогда
		Возврат КэшСконвертированныхОбъектов.Получить(ЗначениеИсточника)
	КонецЕсли;
	ЗначениеПр = Неопределено;
	//Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ЗначениеИсточника)) Тогда
	//	Гуид = ЗначениеИсточника.УникальныйИдентификатор();
	//	ГуидОле = Подключение.NewObject("UUID",СокрЛп(Гуид));
	//	ЗначениеПр = Подключение.Справочники[ЗначениеИсточника.Метаданные().Имя].ПолучитьСсылку(ГуидОле);
	//Иначе
	//Если Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(ЗначениеИсточника)) Тогда
	//	Гуид = ЗначениеИсточника.УникальныйИдентификатор();
	//	ГуидОле = Подключение.NewObject("UUID",СокрЛп(Гуид));
	//	ЗначениеПр = Подключение.Документы[ЗначениеИсточника.Метаданные().Имя].ПолучитьСсылку(ГуидОле) ;
	//ИначеЕсли ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(ТипЗнч(ЗначениеИсточника)) Тогда
	//	Гуид = ЗначениеИсточника.УникальныйИдентификатор();
	//	ГуидОле = Подключение.NewObject("UUID",СокрЛп(Гуид));
	//	ЗначениеПр = Подключение.Документы[ЗначениеИсточника.Метаданные().Имя].ПолучитьСсылку(ГуидОле);
	//ИначеЕсли ПланыСчетов.ТипВсеСсылки().СодержитТип(ТипЗнч(ЗначениеИсточника)) Тогда
	//	Гуид = ЗначениеИсточника.УникальныйИдентификатор();
	//	ГуидОле = Подключение.NewObject("UUID",СокрЛп(Гуид));
	//	ЗначениеПр = Подключение.ПланыСчетов[ЗначениеИсточника.Метаданные().Имя].ПолучитьСсылку(ГуидОле);

//Иначе
	Если ТипЗнч(ЗначениеИсточника) = Тип("Строка") 
			или ТипЗнч(ЗначениеИсточника) = Тип("Число")
			или ТипЗнч(ЗначениеИсточника) = Тип("Дата") Тогда
		ЗначениеПр = ЗначениеИсточника;
	//ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(ТипЗнч(ЗначениеИсточника)) Тогда
		//ИмяПеречисления = ЗначениеИсточника.Метаданные().Имя;
		//ЗначениеПр = Подключение.Перечисления[ЗначениеИсточника.Метаданные().Имя][ИмяПеречисления];
	ИначеЕсли ТипЗнч(ЗначениеИсточника) = Тип("Массив") Тогда
		ЗначениеПр = Подключение.NewObject("Массив");
		Для Каждого ЭлементКоллекцииИст Из ЗначениеИсточника Цикл
			ЗначениеПр.Добавить(СконвертироватьОбъект(ЭлементКоллекцииИст,Подключение,ОбработкаВОЛЕ));
		КонецЦикла;
	ИначеЕсли ТипЗнч(ЗначениеИсточника) = Тип("СписокЗначений") Тогда
		ЗначениеПр = Подключение.NewObject("СписокЗначений");
		Для Каждого ЭлементКоллекцииИст Из ЗначениеИсточника Цикл
			ЗначениеПр.Добавить(СконвертироватьОбъект(ЭлементКоллекцииИст,Подключение,ОбработкаВОЛЕ));
		КонецЦикла;
	ИначеЕсли ТипЗнч(ЗначениеИсточника) = Тип("ТаблицаЗначений") Тогда
		ЗначениеПр = Подключение.NewObject("ТаблицаЗначений");
		Для Каждого Колонка Из ЗначениеИсточника.Колонки Цикл
			ИспользуемыеТипы = Колонка.ТипЗначения.Типы();
			МассивТипов = СконвертироватьОбъект(ИспользуемыеТипы,Подключение,ОбработкаВОЛЕ);
			ОписаниеТиповПр = Подключение.NewObject("ОписаниеТипов",МассивТипов);
			ЗначениеПр.Колонки.Добавить(Колонка.Имя,ОписаниеТиповПр);
		КонецЦикла;
		Для Каждого СтрокаТЗ Из ЗначениеИсточника Цикл
			НоваяСтрока = ЗначениеПр.Добавить();
			Для Каждого Колонка Из ЗначениеИсточника.Колонки Цикл
				НоваяСтрока[Колонка.Имя] = СконвертироватьОбъект(СтрокаТЗ[Колонка.Имя],Подключение,ОбработкаВОЛЕ);
			КонецЦикла;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ЗначениеИсточника) = Тип("МоментВремени") Тогда
		ЗначениеПр = Подключение.NewObject("МоментВремени",ЗначениеИсточника.Дата,
			СконвертироватьОбъект(ЗначениеИсточника.Ссылка,Подключение,ОбработкаВОЛЕ));
	ИначеЕсли ТипЗнч(ЗначениеИсточника) = Тип("Граница") Тогда
		ЗначениеПр = Подключение.NewObject("Граница",СконвертироватьОбъект(ЗначениеИсточника.Значение,Подключение,ОбработкаВОЛЕ),
		СконвертироватьОбъект(ЗначениеИсточника.ВидГраницы,Подключение,ОбработкаВОЛЕ));
		
	ИначеЕсли ТипЗнч(ЗначениеИсточника) = Тип("Тип") Тогда
		ТипВXML = XMLТип(ЗначениеИсточника);
		ЗначениеПр = ОбработкаВОЛЕ.ПолучитьТипПриёмника(ТипВXML.ИмяТипа,ТипВXML.URIПространстваИмен);
	ИначеЕсли ТипЗнч(ЗначениеИсточника) = Тип("ВидГраницы") Тогда
		ЗначениеПр = Подключение.ВидГраницы[Строка(ЗначениеИсточника)]
	Иначе
		//попробуем тупо через xml
		ТипВОле = СконвертироватьОбъект(ТипЗнч(ЗначениеИсточника),Подключение,ОбработкаВОЛЕ);
		Если ТипВОле<>Неопределено Тогда
			ЗначениеПр = Подключение.XMLЗначение(ТипВОле,XMLСтрока(ЗначениеИсточника));
		КонецЕсли;
	КонецЕсли;
	КэшСконвертированныхОбъектов.Вставить(ЗначениеИсточника,ЗначениеПр);
	Возврат ЗначениеПр;
КонецФункции // СконвертироватьОбъект()()

Функция ПолучитьТипПриёмника(ИмяТипа,ПространствоИмен) Экспорт
	Возврат ИзXMLТипа(ИмяТипа,ПространствоИмен);
КонецФункции

//возвращает массив имен временных таблиц, формирующихся в запросе по тексту запроса
//
Функция обПолучитьВременныеТаблицыИзТекстаЗапроса(ТекстДляОбработки) Экспорт
	
	МассивВозврата = Новый Массив;
	
	ПакетЗапросов = Новый Массив;
	
	RegExp = Новый COMОбъект("VBScript.RegExp");
	RegExp.IgnoreCase = Истина;
	RegExp.Global = Истина; 
	RegExp.MultiLine = Истина;
	
	RegExp.Pattern = "[^""]//.*$";
	ТекстДляОбработки = RegExp.Replace(ТекстДляОбработки, "");
	
	RegExp.MultiLine = False;
	//RegExp.Pattern = "(ВЫБРАТЬ)[^;]*";
	RegExp.Pattern = "((ВЫБРАТЬ)[^;]*|(УНИЧТОЖИТЬ)[^;]*)";
	MC = RegExp.Execute(ТекстДляОбработки);
	Для Каждого M Из MC Цикл
		ПакетЗапросов.Добавить(M.Value);
	КонецЦикла;
	
	RegExp.Pattern = "((ПОМЕСТИТЬ)\s+[^;\s]*)";
	
	НомерЗапроса = 1;
	
	ВремяВыполнения = 0; //общее время выполнения запроса
	
	Для Каждого ТекЗапрос Из ПакетЗапросов Цикл
		
		ЭтоВременная = Ложь;
		MC = RegExp.Execute(ТекЗапрос);
		Для Каждого M Из MC Цикл
			ИмяТаблицы = СокрЛП(Сред(СокрЛП(M.Value),11));
			ЭтоВременная = Истина;
			Прервать;
		КонецЦикла;
		
		Если ЭтоВременная Тогда
			
			МассивВозврата.Добавить(ИмяТаблицы);
			
		КонецЕсли; 
		
	КонецЦикла;
	
	RegExp = Неопределено;
	
	Возврат МассивВозврата;
	
КонецФункции //обПолучитьВременныеТаблицыИзТекстаЗапроса

//вывод сообщения на клиенте
//
Процедура обСообщитьПользователюНаКлиенте(ТекстСообщения) Экспорт

	#Если Клиент Тогда
		Сообщить(ТекстСообщения);		
	#КонецЕсли

КонецПроцедуры //обСообщитьПользователюНаКлиенте

Функция СведенияОВнешнейОбработке() Экспорт
  ПараметрыРегистрации = Новый Структура;
  ПараметрыРегистрации.Вставить("Вид", "ДополнительнаяОбработка");
  ПараметрыРегистрации.Вставить("Назначение", );
  ПараметрыРегистрации.Вставить("Наименование", "Запросник 2.0");
  ПараметрыРегистрации.Вставить("Версия", "2.0");
  ПараметрыРегистрации.Вставить("Информация", "Мощный инструмент для отладки запросов");
  ПараметрыРегистрации.Вставить("ВерсияБСП", "1.2.1.4");
  ПараметрыРегистрации.Вставить("БезопасныйРежим",Ложь);
  Команды = ТаблицаКоманд();
  ДобавитьКоманду(Команды,
          "Запросник 2.0",
          "ОткрытьЗапросник",
         "ОткрытиеФормы",
          Ложь,
          Неопределено);
  ПараметрыРегистрации.Вставить("Команды", Команды);
  Возврат ПараметрыРегистрации;
КонецФункции
Функция ТаблицаКоманд()
  Команды = Новый ТаблицаЗначений;
  Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
  Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
  Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
  Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
  Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
  Возврат Команды;
КонецФункции
Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
  НоваяКоманда = ТаблицаКоманд.Добавить();
  НоваяКоманда.Представление = Представление;
  НоваяКоманда.Идентификатор = Идентификатор;
  НоваяКоманда.Использование = Использование;
  НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
  НоваяКоманда.Модификатор = Модификатор;
КонецПроцедуры

Функция Дамп(Запрос) Экспорт
	СтруктураДампа = Новый Структура;
	СтруктураДампа.Вставить("ИБ",СтрокаСоединенияИнформационнойБазы());
	СтруктураДампа.Вставить("ТекстЗапроса",Запрос.Текст);
	СтруктураДампа.Вставить("Параметры",Запрос.Параметры);
	МассивВТ = ПолучитьМассивВТ(Запрос.Текст);
	СекцииЗапроса = ПолучитьМассивТекстовЗапросов(Запрос.Текст);
	МассивСоздаваемыхВТ = Новый Массив;
	Для Каждого СекцияЗапроса Из СекцииЗапроса Цикл
		Если Найти(Врег(СекцияЗапроса),"ПОМЕСТИТЬ")>0 Тогда
			МассивСоздаваемыхВТ.Добавить(ПолучитьИмяВТ(СекцияЗапроса));
		КонецЕсли;
	КонецЦикла;
	СтруктураМенеджераВТ = Новый Структура;
	Для Каждого ВТ Из МассивВТ Цикл
		НашласьВТ = Ложь;
		Для Каждого СоздаваемаяВт Из МассивСоздаваемыхВТ Цикл
			Если Врег(СоздаваемаяВт) = Врег(ВТ) Тогда
				НашласьВт = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НашласьВТ Тогда
			Продолжить;
		КонецЕсли;
		//если не создаётся, то надо запомнить
		Если НЕ СтруктураМенеджераВТ.Свойство(ВТ) Тогда
			ЗапросДляВт = Новый Запрос;
			ЗапросДляВт.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
			ЗапросДляВт.Текст = "Выбрать * Из "+ВТ;
			ТЗВТ = ЗапросДляВт.Выполнить().Выгрузить();
			СтруктураМенеджераВТ.Вставить(ВТ,ТЗВТ);
		КонецЕсли;
	КонецЦикла;
	ИмяДампа = ПолучитьИмяВременногоФайла("sdmp");
	СтруктураДампа.Вставить("МенеджерВТ",СтруктураМенеджераВТ);
	ЗначениеВФайл(ИмяДампа,СтруктураДампа);
	Возврат "Дамп успешно сохранён!";
КонецФункции // Дамп()

Функция ПолучитьМассивВТ(Знач ЗапросИсточник) Экспорт
	//Получить все источники данных
	ЗапросИсточник = УдалитьКомментарииИзЗапроса(ЗапросИсточник);
	ВременныйТекстЗапроса = Врег(ЗапросИсточник);
	ТекстБезВрег = ЗапросИсточник;

	МассивВТ = Новый Массив;
	МассивКлючевыхСлов = Новый Массив;
	МассивКлючевыхСлов.Добавить("ИЗ");
	МассивКлючевыхСлов.Добавить("СОЕДИНЕНИЕ");
	Для Каждого КлючевоеСлово Из МассивКлючевыхСлов Цикл
		Для ВариантПрефикса = 1 по 3 Цикл
			ТекКлючСлово = КлючевоеСлово;
			Если ВариантПрефикса=1 Тогда
				ТекКлючСлово = Символы.ПС + ТекКлючСлово;
			ИначеЕсли ВариантПрефикса = 2 Тогда
				ТекКлючСлово = " " + ТекКлючСлово;
			ИначеЕсли ВариантПрефикса = 3 Тогда
				ТекКлючСлово = "	"+ТекКлючСлово;
			КонецЕсли;
			Для ВариантПостфикcа = 1 по 2 Цикл
				СловоСПрефиксом = ТекКлючСлово;
				Если ВариантПостфикcа = 1 Тогда
					ОкончательноеСлово = СловоСПрефиксом+" ";
				Иначе
					ОкончательноеСлово = СловоСПрефиксом+Символы.ПС;
				КонецЕсли;
				ВременныйТекстЗапроса = Врег(ЗапросИсточник);
				ТекстБезВрег = ЗапросИсточник;
				
				ЧислоСекций = СтрЧислоВхождений(ВременныйТекстЗапроса,ОкончательноеСлово);
				Для Сч = 1 По ЧислоСекций Цикл
					ТекстБезВрег = Сред(ТекстБезВрег,Найти(ВременныйТекстЗапроса,ОкончательноеСлово)+СтрДлина(ОкончательноеСлово),СтрДлина(ВременныйТекстЗапроса));
					ВременныйТекстЗапроса = Сред(ВременныйТекстЗапроса,Найти(ВременныйТекстЗапроса,ОкончательноеСлово)+СтрДлина(ОкончательноеСлово),СтрДлина(ВременныйТекстЗапроса));
					ВременныйТекстЗапроса = СокрЛП(ВременныйТекстЗапроса);
					ТекстБезВрег = СокрЛП(ТекстБезВрег);
					СократитьДоЗначимогоСимвола(ВременныйТекстЗапроса);
					СократитьДоЗначимогоСимвола(ТекстБезВрег);
					НайденныйСимвол = 9999999;
					
					//Следующий пробел или перевод строки
					МассивСимволовКонцаВТ = Новый Массив;
					МассивСимволовКонцаВТ.Добавить(" ");
					МассивСимволовКонцаВТ.Добавить("	");
					МассивСимволовКонцаВТ.Добавить(Символы.ПС);
					МассивСимволовКонцаВТ.Добавить(";");
					МассивСимволовКонцаВТ.Добавить(")");
					
					Для Каждого ПоследнийСимвол Из МассивСимволовКонцаВТ Цикл
						ОчереднойСимвол = Найти(ТекстБезВрег,ПоследнийСимвол);
						Если ОчереднойСимвол>0 Тогда
							Если НайденныйСимвол>ОчереднойСимвол Тогда
								НайденныйСимвол = ОчереднойСимвол;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
					
					НазваниеИсточника = Лев(ТекстБезВрег,НайденныйСимвол-1);
					Если НазваниеИсточника="" Тогда
						Продолжить;
					КонецЕсли;
					Если Лев(НазваниеИсточника,1)="&" или Лев(НазваниеИсточника,1)="(" Тогда
						//ЭтоВТ или вложенныйзапрос
						Продолжить;
					ИначеЕсли Найти(НазваниеИсточника,".")>0 или Врег(НазваниеИсточника)="КОНСТАНТЫ" Тогда
						// это системные таблицы
						Продолжить;
					КонецЕсли;
					Найдено = Неопределено;
					Для Каждого ТекВТ из МассивВТ Цикл
						Если Врег(ТекВТ) = Врег(НазваниеИсточника) Тогда
							Найдено = ТекВТ;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					Если Найдено=Неопределено Тогда
						МассивВТ.Добавить(НазваниеИсточника);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	Возврат МассивВТ;
КонецФункции // ПопытатьсяСоздатьМенеджерВТ()
Функция ПолучитьИмяВТ(ТекЗапрос)
	ТекстПарсинга = Врег(ТекЗапрос);
	ТекстПарсингаБезВрег = ТекЗапрос;
	ПервыйСимвол = Найти(ТекстПарсинга,"ПОМЕСТИТЬ");
	ТекстПарсинга = Сред(ТекстПарсинга,ПервыйСимвол+СтрДлина("Поместить")+1,СтрДлина(ТекстПарсинга));
	ТекстПарсингаБезВрег = Сред(ТекстПарсингаБезВрег,ПервыйСимвол+СтрДлина("Поместить")+1,СтрДлина(ТекстПарсингаБезВрег));
	ТекстПарсинга = СокрЛП(ТекстПарсинга);
	ТекстПарсингаБезВрег = СокрЛП(ТекстПарсингаБезВрег);
	НайденныйСимвол = СтрДлина(ТекстПарсинга);
	МассивСимволовКонцаВТ = Новый Массив;
	МассивСимволовКонцаВТ.Добавить(" ");
	МассивСимволовКонцаВТ.Добавить("	");
	МассивСимволовКонцаВТ.Добавить(Символы.ПС);
	МассивСимволовКонцаВТ.Добавить(";");
	МассивСимволовКонцаВТ.Добавить(")");
	Для Каждого ПоследнийСимвол Из МассивСимволовКонцаВТ Цикл
		ОчереднойСимвол = Найти(ТекстПарсинга,ПоследнийСимвол);
		Если ОчереднойСимвол>0 Тогда
			Если НайденныйСимвол>ОчереднойСимвол Тогда
				НайденныйСимвол = ОчереднойСимвол;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат Лев(ТекстПарсингаБезВрег,НайденныйСимвол-1)

КонецФункции // ПолучитьИмяВТ()

Функция УдалитьКомментарииИзЗапроса(ТекстЗапроса)
	ТекстовыйДокумент = Новый ТекстовыйДокумент;	
	ТекстовыйДокумент.УстановитьТекст(ТекстЗапроса);
	ЧислоСтрок = ТекстовыйДокумент.КоличествоСтрок();
	Для Сч = 1 По ЧислоСтрок Цикл
		ТекСтрока = ТекстовыйДокумент.ПолучитьСтроку(Сч);
		ПозицияКомментария = Найти(ТекСтрока,"//");
		Если ПозицияКомментария>0 Тогда
			ТекСтрока = Лев(ТекСтрока,ПозицияКомментария-1);
			ТекстовыйДокумент.ЗаменитьСтроку(Сч,ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	Возврат ТекстовыйДокумент.ПолучитьТекст();
КонецФункции // УдалитьКомментарииИзЗапроса()


Функция ПолучитьМассивТекстовЗапросов(Знач ТекстИзначальный)
 ТекстИзначальный = УдалитьКомментарииИзЗапроса(ТекстИзначальный);
 ТекстПарсинга = Врег(ТекстИзначальный);
 ТекстБезВрег = ТекстИзначальный;
 МассивЗапросов = Новый Массив;
 КоличествоЗапросовВПакете = СтрЧислоВхождений(ТекстИзначальный,";")+1;
 Для Сч = 1 По КоличествоЗапросовВПакете Цикл
	ТекКонец = Найти(ТекстПарсинга,";");
	Если ТекКонец = 0 Тогда
		Если (Найти(Врег(ТекстПарсинга),"ВЫБРАТЬ")>0) Тогда
			МассивЗапросов.Добавить(ТекстБезВрег);
		ИначеЕсли  Найти(Врег(ТекстПарсинга),"УНИЧТОЖИТЬ")>0 Тогда
			МассивЗапросов.Добавить(ТекстБезВрег+"//&УдалениеВТ");
		КонецЕсли;
	Иначе
		СледующийТекст = Сред(ТекстБезВрег,1,ТекКонец);
		МассивЗапросов.Добавить(СледующийТекст);
		ТекстПарсинга = Сред(ТекстПарсинга,СтрДлина(СледующийТекст)+1,СтрДлина(ТекстПарсинга));
 		ТекстБезВрег = Сред(ТекстБезВрег,СтрДлина(СледующийТекст)+1,СтрДлина(ТекстБезВрег));;
	КонецЕсли;
КонецЦикла;
Возврат МассивЗапросов;
	

КонецФункции // ПолучитьМассивТекстовЗапросов()


обРежимВнешнейОбработки = Не Метаданные.Обработки.Содержит(Метаданные());

обИмяВременногоФайла = КаталогВременныхФайлов() + "query_temp.sel";
обПредставлениеВременногоФайла =  "Из кэша (" + обИмяВременногоФайла + ")";
обОтладкаВнешнегоЗапроса = Ложь;
КэшСконвертированныхОбъектов = Новый Соответствие;