function startFiretalk() {
$('#startFiretalk').hide();
session.signal({
  type: "removeButtons"
  }, function(error) {
    if (error) {
      alert("couldn't tell people to fix buttons");
    }
});

// OWNER LOGIC (Clock every second, muting people, etc.)
// WRAP IN START FUNCTION, EXECUTE ON CLICK

// Players alive is an array containing the connectionIds of all debaters
// throughout the firetalk we will nullify the connections that are dropped
// each round, and keep track of the next speaker (connectionId) in line
var playersAlive = [];
for (var i = 0; i < totalSessions.length; i++) {
  if (totalSessions[i]) {
    playersAlive[i] = totalSessions[i].connection.connectionId;
  }
}

// OWNER START SPEAKING
session.signal({
  type: "adjustAudio",
  data: session.connection.connectionId
},
function(error) {
  if (error) {
    alert("There was an error starting the firetalk with owner");
  }
});

var timer = null;
if (!timer) {
  timer = setInterval(clockwork, 1000);
}

var totalRounds = 2;
var currentRound = 1;
var currentSpeakerIndex = 0;

// Firetalk logic function
// First speaker (owner) is ALREADY speaking when this method is called
function clockwork() {
  // Clock logic
  var currentTimeLeft = parseInt($('#clock').text(), 10);

  // Timer Still going
  if (currentTimeLeft > 0) {
    var newTime = currentTimeLeft - 1;

    // Lets stick these in helper methods
    session.signal({
      data: newTime,
      type: "decrementClock"
    },
    function(error) {
      if (error) {
        alert("Failed to update clock, who knows");
      }
    });
  }
  // Timer Ended (30 seconds up!)
  else {
    // unmute next person, mute everyone else and reset clock to 30 sec (another signal func)
    // if the round is over (bool var?) disconnect the lowest session
    // if we've got a winner, stop everything
    session.signal({
      type: "resetTimer"
    }, function(error) {
      if (error) {
        alert("Failed to reset clock");
      }
    });

    // If we have reached the last speaker (a.k.a it's time for a new round)
    if (isLastSpeakerAlive(currentSpeakerIndex)) {
      alert("reached the last speaker at the end of the timer, current round is " + currentRound);
      // Go back to the beginning of our list at the end of the round
      currentSpeakerIndex = 0;

      // otherwise increment the round and do it again!
      // and drop the lowest dude
      currentRound++;
      dropLowest();
      session.signal({
        type: "nextRound",
        data: currentRound
      },
      function(error) {
        if (error) {
          alert("Failed to tell everyone to increment round...");
        }
      });
      session.signal({
        type:"decrementVote",
        data: totalRounds - currentRound;
      }, function(error) {
        if (error) {

        }
      });
      // If it's the end of the firetalk
      if (currentRound == totalRounds) {
        alert("END OF FIRETALK");
        session.signal({
          type: "unmuteAll"
        },  function(error) {
          if (error) {
            alert("failed to unmute all");
          }
        });
        // Do some winner logic
        clearInterval(timer);
        timer = null;
      }
      else {
        // unmute first person in list
        session.signal({
          type: "adjustAudio",
          data: firstSpeakerAlive()
        }, function(error) {
            if (error) {
              alert("cant send unmute ");
            }
        });
      }
    }
    // There are still more people left to speak (guaranteed)
    else {
      // unmute next speaker
      currentSpeakerIndex++;
      for (var i = currentSpeakerIndex; i < playersAlive.length; i++) {
        var connectionId = playersAlive[i];
        if (connectionId) {
          session.signal({
            type: "adjustAudio",
            data: connectionId
          }, function(error) {
              if (error) {
                alert("cant send unmute ");
              }
          });
          break;
        }
      }
    }
  }
}

// returns connectionId of the first speaker in the list
function firstSpeakerAlive() {
  for (var i = 0; i < playersAlive.length; i++) {
    if (playersAlive[i] != null) {
      return playersAlive[i];
    }
  }
}

// Checks if the given index is the last speaker alive
// or that the rest of the elements after it are null
function isLastSpeakerAlive(index) {
  if (index == 5) {
    return true;
  }
  for (var i = index + 1; i < playersAlive.length; i++) {
    if (playersAlive[i]) {
      return false;
    }
  }
  return true;
}

function lowestPointsIndex() {
  var lowestIndex = 0;
  var lowestConnectionId = firstSpeakerAlive();
  var lowestConnection;
  for (var i = 0; i < totalSessions.length; i++) {
    if (totalSessions[i].connection.connectionId == lowestConnectionId) {
      lowestConnection = totalSessions[i].connection;
    }
  }
  for (var i = 0; i < playersAlive.length; i++) {
    if (playersAlive[i]) {
      var connection = totalSessions[i].connection;
      if (parseInt(connection.data.split("|")[0]) < parseInt(lowestConnection.data.split("|")[0])) {
        lowestIndex = i;
        lowestConnection = connection;
      }
    }
  }
  return lowestIndex;
}

function dropLowest() {
  alert("dropping lowest");
  var index = lowestPointsIndex();
  playersAlive[index] = null;
  var lowestConnection = totalSessions[index].connection;
  session.signal(
    {
      type: "disconnect",
      data: lowestConnection.connectionId
    },
    function(error) {
      console.log("signal error");
    }
  );
}
}
