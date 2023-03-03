//SPDX-License-Identifier: MIT

/* Smart contract que permite a cualquiera realizar un deposito de ETH dentro del contrato, pero solo permite al owner del
contrato retirar los ETH depositados.*/

pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; //https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol"; //https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.6/vendor/SafeMathChainlink.sol

contract FundMe{

    using SafeMathChainlink for uint256; //utilizamos la libreria importada arriba para que nuestros uint no incurran en overflows.
    mapping(address => uint256) public addressToAmountFunder; //mapping para guardar quien y cuanto ETH ha depositado.
    address[] public funders; //array para almacenar las address(usuarios) que han hecho fund.
    address public owner; //address del owner (el que ha desplegado el contrato).


    //los constructores es código que se ejecuta automáticamente justo en el momento en el que se despliega el contrato.
    constructor() public{
        owner = msg.sender; //Aquí indicamos que quien haga el deploy de este contrato se va a convertir en el owner del mismo.
    }


    //El identificador payable en una función indica que esta se va a poder utilizar para pagar cosas.
    function fund() public payable{
        
        uint256 minimumUSD = 50 * 10 **18;
        require(getConversionRate(msg.value) >= minimumUSD, "You need to expend more ETH!"); //permite que para que la sentencia se ejecute antes ha de cunplir unos parametros (como un if)

        addressToAmountFunder[msg.sender] += msg.value; 
        /*msg.sender = es el identificador que va en toda función para indicar desde que address (wallet) se está enviando esa transacción
          msg.value = es el valor de dicha transacción*/ 

          funders.push(msg.sender);
    }


    //Función que interactua con ChainLink PriceFeed (AggregatorV3Interface) haciendo referencia a un contrato que ya está desplegado en una dirección.
    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }


    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        /*Tupla = lista de objetos que pueden tener tipos de datos potencialmente diferentes, y su número es constante 
        al tiempo decompilación, es decir, no se pueden añadir elementos como en las listas una vez compilado.*/
        (,int price,,,) = priceFeed.latestRoundData();
            return uint256(price * 10000000000); //ETH/USD rate in 18 digit.
    }


    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000; // la conversation rate actual de ETH/USD, despues de ajustar los 0's.
        return ethAmountInUsd;
    }


    /*los modificadores se usan para cambiar como se comporta una función de manera declarativa, es decir, nosotros le vamos
    a indicar como va a cambiar: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb*/
    modifier onlyOwner{
        require(msg.sender == owner); //es el mensaje enviado por el owner del contrato?
        _; // esto significa que todo lo demás que vaya a ejecutar, lo ejecutará aquí. Es decir, despues de que acabes con las modificaciones ejecuta el resto del código.
    }


    //función para retirar fondos pero asegurandonos de que el que va a retirar los fondos es el mismo usuario(address) que ha desplegado el contrato
    function withdraw() public payable onlyOwner{
        msg.sender.transfer(address(this).balance);

        //iterar a través de todas las asignaciones y convertirlas en 0 ya que todo el monto depositado ha sido retirado
        for (uint256 funderIndex; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunder[funder] = 0;
        }

        funders = new address[](0); //vaciamos el Array y lo inicializamos en 0.
    }
}