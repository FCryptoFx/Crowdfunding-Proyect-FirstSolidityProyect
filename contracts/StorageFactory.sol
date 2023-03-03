//SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/*El objetivo de este contrato es permitir que a través de StorageFactory podamos hacer una "fabrica" que cree contratos
de tipo SimpleStorage*/

//Importamos el contrato SimpleStorage para poder usarlo en este
import "./SimpleStorage.sol"; //Con el "./" indicamos que el smart contract que estamos importando se encuentra en la misma carpeta.

contract StorageFactory is SimpleStorage { //Con el "is" HEREDAMOS las funciones de SimpleStorage

    //Array que almacene los SimpleStorage que creamos
    SimpleStorage[] public simpleStorageArray;

    //Con esta función creamos contratos SimpleStorage y los añadimos al Array
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        /*Siempre que intentamos interactuar con un smart contract necesitaremos:
         · El address.
         · Application Binary Interface (ABI) -> traduce nuestras instruccionesa un código maquina que la EVM puede entender*/

       //esta línea tiene una conversión explícita al tipo de dirección e inicializa un nuevo objeto SimpleStorage desde la dirección
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber); 

        //esta línea simplemente obtiene el objeto SimpleStorage en el índice _simpleStorageIndex en la matriz simpleStorageArray
        //simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
    }


    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        //esta línea tiene una conversión explícita al tipo de dirección e inicializa un nuevo objeto SimpleStorage desde la dirección
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve(); 

        //esta línea simplemente obtiene el objeto SimpleStorage en el índice _simpleStorageIndex en la matriz simpleStorageArray
        //return simpleStorageArray[_simpleStorageIndex].retrieve(); 
    }
}