&НаКлиенте
Перем ИмяФайла,ИмяПути;
&НаКлиенте
Процедура ПолеРезультатаТекстДляМодуляСкопировать(Команда)
	ВладелецФормы.Элементы.ПолеHTMLДокументаДляБуфераОбмена.Видимость = Истина;
	ОкноDOM = ВладелецФормы.Элементы.ПолеHTMLДокументаДляБуфераОбмена.Документ.ParentWindow;
	ОкноDOM.ClipboardData.SetData("Text",ПолеРезультатаТекстДляМодуля);
	ВладелецФормы.Элементы.ПолеHTMLДокументаДляБуфераОбмена.Видимость = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура КнопкаПараметрАлгоритмаТекстДляМодуляСкопировать(Команда)
	ВладелецФормы.Элементы.ПолеHTMLДокументаДляБуфераОбмена.Видимость = Истина;
	ОкноDOM = ВладелецФормы.Элементы.ПолеHTMLДокументаДляБуфераОбмена.Документ.ParentWindow;
	ОкноDOM.ClipboardData.SetData("Text",ПараметрАлгоритмаТекстДляМодуля);
	ВладелецФормы.Элементы.ПолеHTMLДокументаДляБуфераОбмена.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.НадписьСлева.Заголовок = "Кол. строк в результате: "+ВладелецФормы.РезультатТаблица.Количество();
	СтрокаДереваЗапросов = ВладелецФормы.ДеревоЗапросов.НайтиПоИдентификатору(ВладелецФормы.Элементы.ДеревоЗапросов.Текущаястрока);
	Если СтрокаДереваЗапросов.ТекстАлгоритма<>"" Тогда
		
		//ТекстАлгоритма.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(СтрокаДереваЗапросов.ТекстАлгоритма));
				//обеспечим совместимость со старыми значениями
		СтрокаДереваЗапросов.ТекстАлгоритма = СтрЗаменить(СтрокаДереваЗапросов.ТекстАлгоритма,"Параметры.ТаблицаРезультата","РезультатТаблица");

		ТекстАлгоритма.УстановитьТекст(СтрокаДереваЗапросов.ТекстАлгоритма);
		
		Если СтрокаДереваЗапросов.ПараметрыАлгоритма<>Неопределено Тогда
			ПараметрыАлгоритма = СтрокаДереваЗапросов.ПараметрыАлгоритма;
		КонецЕсли;//  
	Иначе 
		
		УстановитьНачальныйТекстАлгоритма();
		
	КонецЕсли; 
	
КонецПроцедуры
&НаКлиенте
Процедура УстановитьНачальныйТекстАлгоритма()

		//устанавливаем дефолтный текст
		
		ТекстАлгоритмаСтр = "//данный код сформирован автоматически, но скорее всего он Вам пригодится";
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + "Для Каждого СтрокаРезультата Из РезультатТаблица Цикл";
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + "   //алгоритм обработки строки результата - начало ------>";
		
		Если СтруктураРезультатаЗапроса.НайтиСтроки(Новый Структура("Поле","Ссылка")).Количество()>0 Тогда
			//если в списке колонок есть колонка с именем Ссылка, то можно предположить, 
			//что алгоритм будет по изменению объекта по этой ссылке
			//дадим заготовку
			
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.Таб + "Объект1с = СтрокаРезультата.Ссылка.ПолучитьОбъект();";
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.Таб + "//примеры кода:";
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.Таб + "//Объект1с.Комментарий = ПараметрыАлгоритма[0].Значение;";
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.Таб + "//Объект1с.ПометкаУдаления = Истина;";
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.Таб + "//Объект1с.ОбменДанными.Загрузка = Истина;";
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
			ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.Таб + "Объект1с.Записать();";
			
		КонецЕсли; 
		
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + "   //алгоритм обработки строки результата - конец <------";
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + "КонецЦикла;";
		ТекстАлгоритмаСтр = ТекстАлгоритмаСтр + Символы.ПС;
		
		//ТекстАлгоритма.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(ТекстАлгоритмаСтр));
		ТекстАлгоритма.УстановитьТекст(ТекстАлгоритмаСтр);

КонецПроцедуры //УстановитьНачальныйТекстАлгоритма
 


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	МассивДобавляемыхРеквизитов = Новый Массив;
	Для Каждого КолонкаРезультата Из Параметры.СтруктураРезультата Цикл
		НоваяСтрока = СтруктураРезультатаЗапроса.Добавить();
		НоваяСтрока.Поле = КолонкаРезультата.Ключ;
		НоваяСтрока.ПримерЗначения = КолонкаРезультата.Значение;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СтруктураРезультатаЗапросаПриАктивизацииСтроки(Элемент)
	ТекДанные = Элементы.СтруктураРезультатаЗапроса.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда Возврат	КонецЕсли; 
	
	ПолеРезультатаТекстДляМодуля = "СтрокаРезультата." + СокрЛП(ТекДанные.Поле) + ";";

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыАлгоритмаПриАктивизацииСтроки(Элемент)
	ТекДанные = Элементы.ПараметрыАлгоритма.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда Возврат	КонецЕсли; 
	
	ПараметрАлгоритмаТекстДляМодуля = "ПараметрыАлгоритма.НайтиПоИдентификатору("+СокрЛП(Элементы.ПараметрыАлгоритма.ТекущаяСтрока)+").Значение;";

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьАлгоритм(Команда)
	
	ВыполнениеНачало = ТекущаяДата();
	Элементы.НадписьПрерватьВыполнение.Заголовок = "Ctrl + Break - прервать выполнение";
	
	Элементы.НадписьПрерватьВыполнение.Заголовок = "алгоритм выполнен";
	Если АлгоритмВыполняетсяНаСервере() Тогда
		Индикатор = 0;
		ВладелецФормы.ВыполнитьНаСервереПолностью(ТекстАлгоритма.ПолучитьТекст(),ПараметрыАлгоритма,ВыполнятьВТранзакции);
		Индикатор = Элементы.Индикатор.МаксимальноеЗначение;
	Иначе
		Элементы.Индикатор.Видимость = Истина;
		ТекстВыполнения = Новый ТекстовыйДокумент;
		Отказ = Ложь;
		Для Сч = 1 по ТекстАлгоритма.КоличествоСтрок() Цикл
			
			Если НЕ Сч = ОткрытиеЦикла и НЕ Сч = ЗакрытиеЦикла Тогда
				ТекстВыполнения.ДобавитьСтроку(ТекстАлгоритма.ПолучитьСтроку(Сч));
			КонецЕсли;
		КонецЦикла;
		Индикатор = 0;
		Элементы.Индикатор.МаксимальноеЗначение = ВладелецФормы.РезультатТаблица.Количество();
		СтруктураСтрокиВызова = Новый Структура;
		Для Каждого КолонкаРеза Из СтруктураРезультатаЗапроса Цикл 
			СтруктураСтрокиВызова.Вставить(КолонкаРеза.Поле,"");
		КонецЦикла;
		Для Каждого СтрокаРезультата Из ВладелецФормы.РезультатТаблица Цикл
			Индикатор = Индикатор+1;
			ЗаполнитьЗначенияСвойств(СтруктураСтрокиВызова,СтрокаРезультата);
			ВыполнитьАлгоритмНаСервере(ТекстВыполнения.ПолучитьТекст(),СтруктураСтрокиВызова,ПараметрыАлгоритма);
			Если Отказ Тогда
				Прервать;
			КонецЕсли;
			ОбработкаПрерыванияПользователя();
			ОбновитьОтображениеДанных();
		КонецЦикла;
	КонецЕсли;
	
	ВыполнениеКонец = ТекущаяДата();
	ВремяВыполненияВСекундах = ВыполнениеКонец - ВыполнениеНачало;
	Элементы.НадписьВремяВыполнения.Заголовок = "(" + СокрЛП(ВремяВыполненияВСекундах) + " сек.)";

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыполнитьАлгоритмНаСервере(Знач ТекстАлгоритмаВып,Знач СтруктураСтрокиВызова,Знач ПараметрыАлгоритма)
	СтрокаРезультата = СтруктураСтрокиВызова;
	Выполнить(ТекстАлгоритмаВып);

КонецПроцедуры // ВыполнитьАлгоритмНаСервере()

&НаСервере
Процедура ВыполнитьНаСервереПолностью()
	Если ВыполнятьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Выполнить(ТекстАлгоритма.ПолучитьТекст());
	Если ВыполнятьВТранзакции Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
КонецПроцедуры // ВыполнитьНаСервереПолностью()

&НаКлиенте
Функция АлгоритмВыполняетсяНаСервере()
	Если ВыполнятьВТранзакции Тогда
		Возврат Истина;
	КонецЕсли;
	СтрокВсего = ТекстАлгоритма.КоличествоСтрок();
	ОткрытиеЦикла = Ложь;
	ЗакрытиеЦикла = Ложь;
	ВыполнениеНаКлиенте = Истина;
	Для Сч = 1 по СтрокВсего Цикл
		ТекСтрока = СокрЛП(ТекстАлгоритма.ПолучитьСтроку(Сч));
		Если ТекСтрока = "" или Лев(ТекСтрока,2)="//" Тогда
			Продолжить;
		КонецЕсли;
		Если ТекСтрока = "Для Каждого СтрокаРезультата Из РезультатТаблица Цикл" Тогда
			ОткрытиеЦикла = Сч;
			Прервать;
		Иначе
			ВыполнениеНаКлиенте = Ложь;
		КонецЕсли;
	КонецЦикла;
	Для Сч = -СтрокВсего по -1 Цикл
		ТекСтрока = СокрЛП(ТекстАлгоритма.ПолучитьСтроку(-Сч));
		Если ТекСтрока = "" или Лев(ТекСтрока,2)="//" Тогда
			Продолжить;
		КонецЕсли;
		Если ТекСтрока = "КонецЦикла;" Тогда
			ЗакрытиеЦикла = -Сч;
			Прервать;
		Иначе
			ВыполнениеНаКлиенте = Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат НЕ ВыполнениеНаКлиенте;
	
КонецФункции // АлгоритмВыполняетсяНаСервере()
&НаКлиенте
Процедура СохранитьАлгоритмВФайл(НовыйФайл = Ложь)
	
	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
		НовыйФайл = Истина;
	КонецЕсли; 
	
	Если НовыйФайл Тогда
		
		Длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		
		Длг.ПолноеИмяФайла = ИмяФайла;
		Длг.Каталог = ИмяПути;
		Длг.Заголовок = "Укажите файл";
		Длг.Фильтр = "Файлы запросов (*.alg)|*.alg|Все файлы (*.*)|*.*";
		Длг.Расширение = "alg";
		
		Если Длг.Выбрать() Тогда
			ИмяФайла = Длг.ПолноеИмяФайла;
			ИмяПути = Длг.Каталог;
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли; 
	
	Попытка
		
		СтруктураСохранения = Новый Структура("ТекстАлгоритма,ПараметрыАлгоритма");
		СтруктураСохранения.ТекстАлгоритма = ТекстАлгоритма.ПолучитьТекст();
		СтруктураСохранения.ПараметрыАлгоритма = ПараметрыАлгоритма;
		СтруктураТекст = ЗначениеВСтроку(СтруктураСохранения);
		ТекстовыйДок = Новый ТекстовыйДокумент;
		ТекстовыйДок.УстановитьТекст(СтруктураТекст);
		ТекстовыйДок.Записать(ИмяФайла);
		

	Исключение
		
		Сообщить(ОписаниеОшибки());
		Возврат;
		
	КонецПопытки;
	
	Модифицированность = Ложь;
	
	Заголовок = ИмяФайла;
	
КонецПроцедуры //СохранитьАлгоритмВФайл

&НаСервере
Функция ЗначениеВСтроку(Значение)
	Возврат ЗначениеВСтрокуВнутр(Значение);
КонецФункции // ЗначениеВСтроку()


&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
		//сохраняем текст алгоритма в строке дерева запросов
	СтрокаДереваЗапросов = ВладелецФормы.ДеревоЗапросов.НайтиПоИдентификатору(ВладелецФормы.Элементы.ДеревоЗапросов.Текущаястрока);
	СтрокаДереваЗапросов.ТекстАлгоритма = ТекстАлгоритма.ПолучитьТекст();
	СтрокаДереваЗапросов.ПараметрыАлгоритма = ПараметрыАлгоритма;
	//если алгоритм модифицирован - установим модифицированность и в основной форме
	ВладелецФормы.Модифицированность = Модифицированность;
	

КонецПроцедуры

&НаКлиенте
Процедура СохранитьАлгоритм(Команда)
	СохранитьАлгоритмВФайл(ИмяФайла=Неопределено);
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьАлгоритм(Команда)
	Длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Длг.ПолноеИмяФайла = ИмяФайла;
	Длг.Каталог = ИмяПути;
	Длг.Заголовок = "Выберите файл со списком запросов";
	Длг.Фильтр = "Файлы запросов (*.alg)|*.alg|Все файлы (*.*)|*.*";
	Длг.Расширение = "alg";
	
	Если Длг.Выбрать() Тогда
		ИмяФайла = Длг.ПолноеИмяФайла;
		ИмяПути = Длг.Каталог;
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ИмяФайла);
		СтруктураСохранения = ПрочитатьЗначение(ТекстовыйДокумент.ПолучитьТекст());
		ПараметрыАлгоритма = СтруктураСохранения.ПараметрыАлгоритма;
		ТекстАлгоритма.УстановитьТекст(СтруктураСохранения.ТекстАлгоритма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПрочитатьЗначение(Текст)
	Возврат ЗначениеИзСтрокиВнутр(Текст);
	

КонецФункции // ПрочитатьЗначение()


&НаКлиенте                                          
Процедура СохранитьКак(Команда)
	СохранитьАлгоритмВФайл(Истина);
КонецПроцедуры


&НаКлиенте                                        
Процедура СтруктураРезультатаЗапросаНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	// Вставить содержимое обработчика.
	ПараметрыПеретаскивания.Значение = ПолеРезультатаТекстДляМодуля;
КонецПроцедуры                                      

&НаКлиенте
Процедура ПараметрыАлгоритмаНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	ПараметрыПеретаскивания.Значение = ПараметрАлгоритмаТекстДляМодуля;
КонецПроцедуры


