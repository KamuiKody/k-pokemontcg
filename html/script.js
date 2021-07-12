let pokemon = 'metapod';

let flippedcard1 = false;
let flippedcard2 = false;
let flippedcard3 = false;
let flippedcard4 = false;

document.onkeyup = function (data) {
    if (data.which == 27) { // Escape
        $.post('https://qb-pokemontcg/CloseNui')
        setTimeout(() => { $('.cards').css("display", "none"); }, 2000);
        $('.cards').animate({"top": "100%"}, 450)

        if (flippedcard1 === true) {
            var card = document.querySelector('.card');
            card.classList.toggle('is-flipped');
            flippedcard1 = false
        }
        if (flippedcard2 === true) {
            var card = document.querySelector('.card2');
            card.classList.toggle('is-flipped');
            flippedcard2 = false
        }

        if (flippedcard3 === true) {
            var card = document.querySelector('.card3');
            card.classList.toggle('is-flipped');
            flippedcard3 = false
        }

        if (flippedcard4 === true) {
            var card = document.querySelector('.card4');
            card.classList.toggle('is-flipped');
            flippedcard4 = false
        }

    }
};

addEventListener("message", function(event){
    let item = event.data;

    if(item.open == true) {
        if (item.class == "open") {
            $('.cards').css("display", "block");
            $('.cards').animate({"top": "30%"}, 450)
        } 
        if (item.class == "choose") {
            pokemon = item.data   
        } 
    }
});


$(document).on('click', '.card', function(e){
    e.preventDefault();
    var card = document.querySelector('.card');
    if (flippedcard1 === false) {
        card.classList.toggle('is-flipped');
        $.post('https://qb-pokemontcg/randomCard');

        setTimeout(() => { 
            document.getElementById("myImg").src = "img/" + pokemon + ".png";
            $.post('https://qb-pokemontcg/Rewardpokemon', JSON.stringify({
                Pokemon: pokemon,
            }))
        }, 200);

        flippedcard1 = true
    }
});

$(document).on('click', '.card2', function(e){
    e.preventDefault();
    var card = document.querySelector('.card2');
    if (flippedcard2 === false) {
        card.classList.toggle('is-flipped');
        $.post('https://qb-pokemontcg/randomCard');

        setTimeout(() => {
            document.getElementById("myImg2").src = "img/" + pokemon + ".png";
            $.post('https://qb-pokemontcg/Rewardpokemon', JSON.stringify({
                Pokemon: pokemon,
            }))
        }, 200);

    
        flippedcard2 = true
    }
});

$(document).on('click', '.card3', function(e){
    e.preventDefault();
    var card = document.querySelector('.card3');
    if (flippedcard3 === false) {
        card.classList.toggle('is-flipped');
        $.post('https://qb-pokemontcg/randomCard');

        setTimeout(() => {
            document.getElementById("myImg3").src = "img/" + pokemon + ".png";
            $.post('https://qb-pokemontcg/Rewardpokemon', JSON.stringify({
                Pokemon: pokemon,
            }))
        }, 200);

        
        flippedcard3 = true
    }
});

$(document).on('click', '.card4', function(e){
    e.preventDefault();
    var card = document.querySelector('.card4');
    if (flippedcard4 === false) {
        card.classList.toggle('is-flipped');
        $.post('https://qb-pokemontcg/randomCard');

        setTimeout(() => {
            document.getElementById("myImg4").src = "img/" + pokemon + ".png"; 
            $.post('https://qb-pokemontcg/Rewardpokemon', JSON.stringify({
                Pokemon: pokemon,
            }))
        }, 200);

        
        flippedcard4 = true
    }
});
