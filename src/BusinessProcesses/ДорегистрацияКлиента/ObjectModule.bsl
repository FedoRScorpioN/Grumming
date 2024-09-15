#Область ОбработчикиСобытий

Процедура ПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	Для каждого ФормируемаяЗадача Из ФормируемыеЗадачи Цикл
		ФормируемаяЗадача.Наименование = СтрШаблон("Получить согласие клиента %1 на регистрацию", Пользователь.Наименование);
		ФормируемаяЗадача.Предмет = Пользователь.Ссылка;
		ФормируемаяЗадача.ОписаниеЗадачи = СтрШаблон("Из мобильного приложения поступила заявка на регистрацию пользователя. "+
		"Необходимо созвониться с клиентом %1 по телефону %2 и получить согласие на регистрацию, а так же дозаполнить карточку клиента "+
		"- ФИО, Дату рождения, сведения о питомцах и другие данные, которые клиент согласен предоставить.",
		Пользователь.Наименование, Пользователь.Клиент.Ссылка.КонтактныйТелефон);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодтверждениеРегистрацииПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	РегистрацияПодтверждена = Задача.ПолученоСогласие;
КонецПроцедуры

Процедура КлиентПодтвердилРегистрациюПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = РегистрацияПодтверждена;
КонецПроцедуры

Процедура ПометкаНаУдалениеПользователяОбработка(ТочкаМаршрутаБизнесПроцесса)
	ЗаблокироватьДанныеДляРедактирования(Пользователь);
	Объект = Пользователь.ПолучитьОбъект();
	Объект.УстановитьПометкуУдаления(Истина);
	Объект.Записать();
	РазблокироватьДанныеДляРедактирования(Пользователь);
КонецПроцедуры

#КонецОбласти