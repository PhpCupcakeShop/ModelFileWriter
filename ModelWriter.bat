@echo off
setlocal enabledelayedexpansion
rem Prompt the user for the model name
set /p modelName="Enter the model/class/object name: "
set /p tableName="Enter the name for the MySQL table: "
set /p userFriendName="Enter a user friendly name for the model/object: "
rem Prompt the user for the number of properties
set /p numProperties="Enter the number of properties: "


rem Loop through the properties and prompt the user for names
for /l %%i in (1,1,%numProperties%) do (
    set /p "propertyName_%%i=Enter property name %%i: "
    rem Prompt the user for the property metadata
    set /p "Type_%%i=Enter the type for the !propertyName_%%i! property: "
    set /p "Length_%%i=Enter the length for the !propertyName_%%i! property (leave empty to skip): "
    set /p "Extra_%%i=Enter the extra information for the !propertyName_%%i! property: "
    set /p "IsSearchable_%%i=Enter the isSearchable value for the !propertyName_%%i! property (true/false): "
    set /p "SearchableByAdmin_%%i=Enter the searchableByAdmin value for the !propertyName_%%i! property (true/false) (mark true if true above): "
    set /p "IsForm_%%i=Enter the isForm value for the !propertyName_%%i! property (true/false): "
    set /p "IsLink_%%i=Enter the isLink value for the !propertyName_%%i! property (true/false): "
    set /p "Display_%%i=Enter the display value for the !propertyName_%%i! property (true/false): "
    set /p "UserFriendlyName_%%i=Enter the userFriendlyName for the !propertyName_%%i!: "
    set /p "Formfield_%%i=Enter the formfield for the !propertyName_%%i! property: "
    set /p "Placeholder_%%i=Enter the placeholder for the !propertyName_%%i! property: "
    set /p "SortbyAsc_%%i=Enter the sortbyAsc value for the !propertyName_%%i! property (true/false): "
    set /p "UserFriendlyAsc_%%i=Enter the userFriendlyName for the !propertyName_%%i! sort ASC property (ex. name a-z): "
    set /p "SortbyDesc_%%i=Enter the sortbyDesc value for the !propertyName_%%i! property (true/false): "
    set /p "UserFriendlyDesc_%%i=Enter the userFriendlyName for the !propertyName_%%i! sort DESC property (ex. price low to high): "
)


rem Create the file with the specified model name
echo ^<?php^ >> temp.txt
echo namespace PhpCupcakes\Models; >> temp.txt
echo. >> temp.txt
echo use PhpCupcakes\DAL\VanillaCupcakeDAL; >> temp.txt
echo. >> temp.txt
echo class %modelName% >> temp.txt
echo { >> temp.txt
echo     public $id; >> temp.txt
rem Loop through the properties and add them to the class
for /l %%i in (1,1,%numProperties%) do (
    echo     public $!propertyName_%%i!; >> temp.txt
)

echo     public $CREATED_AT; >> temp.txt
echo. >> temp.txt
echo     public static $propertyMetadata = [ >> temp.txt
echo         'id' =^> ['type' =^> 'INT', >> temp.txt
echo             'length' =^> 11, >> temp.txt
echo             'extra' =^> 'AUTO_INCREMENT PRIMARY KEY', >> temp.txt
echo             'isSearchable'=^> false, >> temp.txt
echo             'searchableByAdmin'=^> true, >> temp.txt
echo             'isForm' =^> true, >> temp.txt
echo             'display' =^> false, >> temp.txt
echo             'userFriendlyName' =^> 'id', >> temp.txt
echo             'formfield' =^> 'Hidden', >> temp.txt
echo             'placeholder' =^> null, >> temp.txt
echo             'sortbyAsc' =^> false, >> temp.txt
echo             'sortbyDesc' =^> false], >> temp.txt

rem Loop through the properties and add their metadata
for /l %%i in (1,1,%numProperties%) do (
echo         '!propertyName_%%i!' =^> ['type' =^> '!Type_%%i!', >> temp.txt
if defined Length_%%i (
    echo 'length' =^> !Length_%%i!, >> temp.txt
) else (
    echo //Variable !Length_%%i! is not defined >> temp.txt
)
                
echo                'extra' =^> '!Extra_%%i!', >> temp.txt
echo                'isSearchable'=^> '!IsSearchable_%%i!', >> temp.txt
echo                'searchableByAdmin'=^> '!SearchableByAdmin_%%i!', >> temp.txt
echo                'isForm' =^> !IsForm_%%i!, >> temp.txt
echo                'isLink' =^> !IsLink_%%i!, >> temp.txt
echo                'display' =^> !Display_%%i!, >> temp.txt
echo                'userFriendlyName' =^> '!UserFriendlyName_%%i!', >> temp.txt
echo                'formfield' =^> '!Formfield_%%i!', >> temp.txt
echo                'placeholder' =^> '!Placeholder_%%i!', >> temp.txt
echo                'sortbyAsc' =^> !SortbyAsc_%%i!, >> temp.txt
echo                'userFriendlySortAsc' =^> '!UserFriendlyNameAsc_%%i!', >> temp.txt
echo                'sortbyDesc' =^> !SortbyDesc_%%i!, >> temp.txt
echo                'userFriendlySortDesc' =^> '!UserFriendlyNameDesc_%%i!'], >> temp.txt
)

echo         'CREATED_AT' =^> ['type' =^> 'TIMESTAMP', >> temp.txt
echo             'extra' =^> 'DEFAULT CURRENT_TIMESTAMP NOT NULL', >> temp.txt
echo             'isSearchable'=^> false, >> temp.txt
echo             'searchableByAdmin'=^> false, >> temp.txt
echo             'isForm' =^> false, >> temp.txt
echo             'display' =^> false, >> temp.txt
echo             'sortbyAsc' =^> true, >> temp.txt
echo             'userFriendlySortAsc' =^> 'oldest', >> temp.txt
echo             'sortbyDesc' =^> true, >> temp.txt
echo             'userFriendlySortDesc' =^> 'newest'] >> temp.txt
echo     ]; >> temp.txt

rem Add the rest of the class methods
echo. >> temp.txt
echo     public static function getTableName() >> temp.txt
echo     { >> temp.txt
echo         return '%tableName%'; >> temp.txt
echo     } >> temp.txt
echo. >> temp.txt
echo     public static function getUserFriendlyName() >> temp.txt
echo     { >> temp.txt
echo         return '%userFriendName%'; >> temp.txt
echo     } >> temp.txt
echo. >> temp.txt
echo     public function save() >> temp.txt
echo     { >> temp.txt
echo         VanillaCupcakeDAL::save($this); >> temp.txt
echo     } >> temp.txt
echo. >> temp.txt
echo     public static function find($id) >> temp.txt
echo     { >> temp.txt
echo         return VanillaCupcakeDAL::find(__CLASS__, $id); >> temp.txt
echo     } >> temp.txt
echo. >> temp.txt
echo     public static function findAll() >> temp.txt
echo     { >> temp.txt
echo         return VanillaCupcakeDAL::findAll(__CLASS__); >> temp.txt
echo     } >> temp.txt
echo. >> temp.txt
echo     public static function findAllPaginateSorted($currentPage, $itemsPerPage) >> temp.txt
echo     { >> temp.txt
echo         return VanillaCupcakeDAL::findAllPaginateSorted(__CLASS__, $currentPage, $itemsPerPage); >> temp.txt
echo     } >> temp.txt
echo. >> temp.txt
echo     public static function getTotalofAll() >> temp.txt
echo     { >> temp.txt
echo         return VanillaCupcakeDAL::getTotalofAll(__CLASS__); >> temp.txt
echo     } >> temp.txt
echo. >> temp.txt
echo     public static function searchOneTable($searchQuery, $columnName, $currentPage = 1, $itemsPerPage = 10) >> temp.txt
echo     { >> temp.txt
echo         return VanillaCupcakeDAL::searchOneTable(__CLASS__, $searchQuery, $columnName, $currentPage = 1, $itemsPerPage = 10); >> temp.txt
echo     } >> temp.txt
echo. >> temp.txt
echo     public static function delete($id) >> temp.txt
echo     { >> temp.txt
echo         VanillaCupcakeDAL::delete(__CLASS__, $id); >> temp.txt
echo     } >> temp.txt
echo } >> temp.txt


rem Replace the escaped "^>" with ">"
findstr /v "^>" temp.txt > %modelName%.php
del temp.txt