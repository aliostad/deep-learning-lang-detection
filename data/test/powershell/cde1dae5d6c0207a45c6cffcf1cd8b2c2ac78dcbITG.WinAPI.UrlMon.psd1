#
# Манифест модуля для модуля "ITG.WinAPI.UrlMon".
#
# Создано: Sergey S. Betke
#
# Дата создания: 08.10.2012
#
# Архив проекта: https://github.com/sergey-s-betke/ITG.WinAPI
#

@{

# Файл модуля скрипта или двоичного модуля, связанный с данным манифестом
ModuleToProcess = 'ITG.WinAPI.UrlMon.psm1'

# Номер версии данного модуля.
ModuleVersion = '2.0.2'

# Уникальный идентификатор данного модуля
GUID = 'd458bfbb-1a1a-4b36-aa39-d35018456959'

# Автор данного модуля
Author = 'Sergey S. Betke'

# Компания, создавшая данный модуль, или его поставщик
CompanyName = 'IT-Service.Nov.RU'

# Заявление об авторских правах на модуль
Copyright = '(c) 2012 Sergey S. Betke. All rights reserved.'

# Описание функций данного модуля
Description = 'Обёртки для Windows API UrlMon.dll и командлеты на их основе'

# Минимальный номер версии обработчика Windows PowerShell, необходимой для работы данного модуля
PowerShellVersion = '2.0'

# Имя узла Windows PowerShell, необходимого для работы данного модуля
PowerShellHostName = ''

# Минимальный номер версии узла Windows PowerShell, необходимой для работы данного модуля
PowerShellHostVersion = ''

# Минимальный номер версии компонента .NET Framework, необходимой для данного модуля
DotNetFrameworkVersion = '2.0'

# Минимальный номер версии среды CLR (общеязыковой среды выполнения), необходимой для работы данного модуля
CLRVersion = '2.0'

# Архитектура процессора (нет, X86, AMD64, IA64), необходимая для работы модуля
ProcessorArchitecture = ''

# Модули, которые необходимо импортировать в глобальную среду перед импортированием данного модуля
RequiredModules = @()

# Сборки, которые должны быть загружены перед импортированием данного модуля
RequiredAssemblies = @()

# Файлы скрипта (.ps1), которые запускаются в среде вызывающей стороны перед импортированием данного модуля
ScriptsToProcess = @(
	'ITG.PrepareModulesEnv.ps1'
)

# Файлы типа (.ps1xml), которые загружаются при импорте данного модуля
TypesToProcess = @(
    'ITG.WinAPI.UrlMon.Types.ps1xml'
)

# Файлы формата (PS1XML-файлы), которые загружаются при импорте данного модуля
FormatsToProcess = @()

# Модули для импортирования в модуль, указанный в параметре ModuleToProcess, в качестве вложенных модулей
NestedModules = @()

# Функции для экспорта из данного модуля
FunctionsToExport = '*'

# Командлеты для экспорта из данного модуля
CmdletsToExport = '*'

# Переменные для экспорта из данного модуля
VariablesToExport = '*'

# Псевдонимы для экспорта из данного модуля
AliasesToExport = '*'

# Список всех модулей, входящих в пакет данного модуля
ModuleList = @()

# Список всех файлов, входящих в пакет данного модуля
FileList = `
	'ITG.WinAPI.UrlMon.psm1',
	'ITG.WinAPI.UrlMon.Types.ps1xml',
	'ITG.PrepareModulesEnv.ps1'

# Личные данные, передаваемые в модуль, указанный в параметре ModuleToProcess
PrivateData = ''

}