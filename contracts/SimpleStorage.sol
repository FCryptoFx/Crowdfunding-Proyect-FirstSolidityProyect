// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0; //Con el símbolo ^ indicamos el rango de versión que deseamos, en este caso entre la v0.6.0 y la 0.7.0

contract SimpleStorage {

    /*Tipos de variables:
    uint256 favoriteNumber = 10; //acepta solo números positivos
    int256 favoriteInt = -10; //acepta tambien números negativos
    bool favoriteBool = true;
    string favoriteString = "Hello world";
    address favoriteAdress = 0x35117ea5ba8618ee43DBc26Db075b09140631A51;
    bytes8 favoriteByte = "Hello"; //Tipo de dato que recoge lo que tengas y lo pasa al ByteCode. Sirve para procesar de manera computacional los datos que estamos enviando a la EVM*/

    uint256 favoriteNumber;

    //Estructura de datos complejos (lo entiendo como el constructor de un objeto).
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;
    //Los mappings son estructuras que relacionan un tipo de dato con otro.
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    
    /* view = nos sirven para obtener información de algo que ya está almacenado dentro de la blockchain 
    (Ej. dato de una variable, info sobre otro tipo de estructura o info almacenada).
    Las funciones view no cuestan Gas porque solamente hacen una llamada, no modifican la blockchain.*/
    function retrieve() public view returns (uint256){
        return favoriteNumber;
    }

    //pure = hacen una operación matemática
    function pureFunction(uint256 _number) public pure{
        _number + _number;
    }

    /*Cuando utilizamos el tipo de variable string, al ser tipo de dato especial, tenemos que indicarle al compilador de
    Solidity que debe hacer con el. Puede ser lo siguiente:
    · memory -> hace que esta variable viva solamente durante la ejecución de la función en la que se encuantra. Una vez que la función se ejecuta, la variable se elimina.
    · storage -> la variable va a permanecer durante el tiempo.*/
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}