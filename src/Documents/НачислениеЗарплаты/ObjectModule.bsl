#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.Начисления.Записывать        = Истина;
	Движения.УчетЗатрат.Записывать        = Истина;
	Движения.Хозрасчетный.Записывать      = Истина;
	
	Для Каждого ТекСтрокаНачисления Из Начисления Цикл
		Движение = Движения.Начисления.Добавить();
		Движение.Сторно                 = Ложь;
		Движение.ВидРасчета             = ТекСтрокаНачисления.ВидРасчета;
		Движение.ПериодДействияНачало   = ТекСтрокаНачисления.ДатаНачала;
		Движение.ПериодДействияКонец    = ТекСтрокаНачисления.ДатаОкончания;
		Движение.ПериодРегистрации      = ПериодНачисления;
		Движение.БазовыйПериодНачало    = ТекСтрокаНачисления.ДатаНачала;
		Движение.БазовыйПериодКонец     = ТекСтрокаНачисления.ДатаОкончания;
		Движение.Сотрудник              = ТекСтрокаНачисления.Сотрудник;
		Движение.ПоказательРасчета      = ТекСтрокаНачисления.ПоказательРасчета;
		Движение.График                 = ТекСтрокаНачисления.ГрафикРаботы;    
	КонецЦикла;
	
	Движения.Начисления.Записать();
	Движения.Начисления.РассчитатьСуммуНачисления(); 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Начисления.Сотрудник КАК Сотрудник,
	|	Начисления.Сумма КАК Сумма,
	|	Начисления.ВидРасчета.СтатьяЗатрат КАК СтатьяЗатрат
	|ИЗ
	|	РегистрРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.Регистратор = &Регистратор
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	СтатьяЗатрат";
	
	Запрос.УстановитьПараметр("Регистратор", ЭтотОбъект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаИтогиПоСтатье = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаИтогиПоСтатье.Следующий() Цикл
		ДвижениеЗатрат = Движения.УчетЗатрат.Добавить();
		ДвижениеЗатрат.Период = Дата;
		ЗаполнитьЗначенияСвойств(ДвижениеЗатрат, ВыборкаИтогиПоСтатье);
		ВыборкаДетальные = ВыборкаИтогиПоСтатье.Выбрать(); 
		Пока ВыборкаДетальные.Следующий() Цикл
			ДвижениеХозрасчетный = Движения.Хозрасчетный.Добавить();
			ДвижениеХозрасчетный.СчетДт        = ПланыСчетов.Хозрасчетный.РасходыНаПродажу;
			ДвижениеХозрасчетный.СчетКт        = ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда;
			ДвижениеХозрасчетный.Период        = Дата;
			ДвижениеХозрасчетный.Сумма         = ВыборкаДетальные.Сумма;
			ДвижениеХозрасчетный.Содержание    = "Отражено начисление заработной платы сотрудникам";
			БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(ДвижениеХозрасчетный.СчетДт,
			ДвижениеХозрасчетный.СубконтоДт, ВыборкаДетальные.СтатьяЗатрат);
			БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(ДвижениеХозрасчетный.СчетКт,
			ДвижениеХозрасчетный.СубконтоКт, ВыборкаДетальные.Сотрудник);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти