// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;

contract Hundir_la_flota{

    address public ownerJuego;
    address public jugador_1;
    address public jugador_2;
    uint public participantes;
    uint public tablero = 3;    //El tablero sera cuadrado
    uint public turno = 1;  //Siempre empezara el jugador 1      
    uint [2] private barco1;
    uint [2] private barco2;
    constructor(){
        ownerJuego = msg.sender;
        participantes = 0;
    }

    //Los parametros de entrada van a ser la posicion del barco
    function comprarEntrada(uint x, uint y) public payable{
        //Condiciones para participar
        require(msg.sender != ownerJuego, "El dueno del juego no puede participar");  
        require(msg.value == 10 ether, "No tienes suficiente dinero como para comprar una entrada");
        require(participantes < 2, "El juego esta lleno, espera hasta que se termine.");
        require(x<=tablero, "No puedes colocar el barco fuera del tablero (3x3)");
        require(y<=tablero, "No puedes colocar el barco fuera del tablero (3x3)");
        require(jugador_1 != msg.sender, "No se puede participar dos veces!");

        if(participantes == 0) {
            jugador_1 = msg.sender;
            barco1[0] = x;
            barco1[1] = y;
        } 
        else {
            jugador_2 = msg.sender;
            barco2[0] = x;
            barco2[1] = y;
        }            
        participantes++;         
    }

    //Empieza el jugador 1
    function disparar (uint x, uint y) public payable{
        require(participantes == 2, "Para jugar tiene que haber dos participantes.");
        require(msg.value == 1 ether, "Cada intento vale un ether.");
        require(x<=tablero, "Las coordenadas son erroneas (3x3)");
        require(y<=tablero, "Las coordenadas son erroneas (3x3)");
        if(turno == 1) require(msg.sender == jugador_1, "Es turno del jugador 1, espera.");
        if(turno == 2) require(msg.sender == jugador_2, "Es turno del jugador 2, espera.");

        if(turno == 1 && msg.sender == jugador_1) {     //Turno del jugador 1
            if(barco2[0] == x && barco2[1] == y){
                payable(jugador_1).transfer(address(this).balance);
            }
            turno = 2;
        } else if (turno == 2 && msg.sender == jugador_2){
            if (barco1[0] == x && barco1[1] == y){
                payable(jugador_2).transfer(address(this).balance);
            }
            turno = 1;
        }
    }
}