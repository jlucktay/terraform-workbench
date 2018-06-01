var Alexa = require('alexa-sdk');

exports.handler = function (event, context, callback) {
    var alexa = Alexa.handler(event, context);

    alexa.registerHandlers(handlers);
    alexa.execute();
};

var handlers = {
    'LaunchRequest': function () {
        this.emit('GetNewFactIntent');
    },

    'GetNewFactIntent': function () {
        var say = 'Hello Jimmy! Lets begin studying for our exam!' + getFact();
        this.emit(':tell', say);
    },

    'AMAZON.HelpIntent': function () {
        this.emit(':ask', 'Learn everything you need to know about Amazon Web Services to pass your exam by listening to your very own study notes. You can start by saying, Jimmy help me study.', 'try again');
    },

    'AMAZON.CancelIntent': function () {
        this.emit(':tell', 'Goodbye Cloud Gurus');
    },

    'AMAZON.StopIntent': function () {
        this.emit(':tell', 'Goodbye Cloud Gurus');
    }
};

//  helper functions  ===================================================================

function getFact() {
    var myFacts = [
        '<audio src=\"https://s3.eu-west-2.amazonaws.com/alexa-and-polly/2c1a5f18-d9a4-4174-8e20-cb27a219c244.mp3" />\'',
        '<audio src=\"https://s3.eu-west-2.amazonaws.com/alexa-and-polly/2fdfaca4-84e4-4eb5-8ea5-4ccf5099d588.mp3" />\'',
        '<audio src=\"https://s3.eu-west-2.amazonaws.com/alexa-and-polly/44c59863-21b7-466e-9740-c419aeec29bc.mp3" />\'',
        '<audio src=\"https://s3.eu-west-2.amazonaws.com/alexa-and-polly/46bd2889-80df-4238-9476-570ab11c13d5.mp3" />\'',
        '<audio src=\"https://s3.eu-west-2.amazonaws.com/alexa-and-polly/4863c736-53b2-4867-a1df-52e3611d6a6e.mp3" />\'',
        '<audio src=\"https://s3.eu-west-2.amazonaws.com/alexa-and-polly/7634fb4e-0b1c-4052-8049-a496d802e48f.mp3" />\'',
        '<audio src=\"https://s3.eu-west-2.amazonaws.com/alexa-and-polly/e43bf26d-bd84-4f6d-9f60-7fa33c0d65ff.mp3" />\''
    ]

    var newFact = randomPhrase(myFacts);

    return newFact;
}

function randomPhrase(array) {
    // the argument is an array [] of words or phrases
    var i = 0;
    i = Math.floor(Math.random() * array.length);
    return (array[i]);
}
