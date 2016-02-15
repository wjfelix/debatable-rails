var apiKey = '45241592';
var sessionId = "<%= j @firetalk.tok_session_id %>";
var token = "<%= j @tok_token %>";
var myEmail = "<%= j @user.email %>"
var debatersJson = JSON.parse("<%= j @firetalk_json.to_s.html_safe %>");

// starting number of points
var votingPoints = 3;

// connecting logic
TB.setLogLevel(TB.DEBUG);
var session = TB.initSession(sessionId);
var totalSessions = [];

session.addEventListener('sessionConnected', sessionConnectedHandler);
session.addEventListener('streamCreated', streamCreatedHandler);
session.addEventListener('streamPropertyChanged', streamPropertyChangedHandler)
session.connect(apiKey, token);

var publisher;
var speakerNumber;

function sessionConnectedHandler(event) {
    speakerNumber = parseInt(debatersJson[myEmail] + 1);
    publisher = OT.initPublisher(apiKey, "speaker" + speakerNumber + "Box");
    session.publish(publisher);
    var id = document.createTextNode(String(session.connection.connectionId));
    document.body.appendChild(id);

    // Subscribe to streams that were in the session when we connected
    subscribeToStreams(event.streams);
}

function streamCreatedHandler(event) {
    subscribeToStreams(event.streams);
}

function subscribeToStreams(streams) {
  for (var i = 0; i < streams.length; i++) {
    // Make sure we don’t subscribe to ourself
    if (streams[i].connection.connectionId == session.connection.connectionId) {
      return;
    }
    // Create the div to put the subscriber element in to
    var div = document.createElement('div');
    div.setAttribute('id', 'stream' + streams[i].streamId);

    var connection = streams[i].connection;
    var email = connection.data.split("|")[1];
    var newSpeakerNumber = parseInt(debatersJson[email]) + 1;
    document.getElementById("speaker" + newSpeakerNumber + "Box").appendChild(div);

    // Subscribe to the stream
    session.subscribe(streams[i], div.id);
  }
}

function streamPropertyChangedHandler() {

}

function decrementVote() {
  session.signal({
    to: session.connection,
    type: "decrementVote",
    data: votingPoints - 1
  }, function(error) {
    if (error) {
      alert("error decrementing votes");
    }
  });
}

// BROADCAST SIGNAL EVENTS
$('#speakerOnePoints').click(function() {
  if (parseInt(document.getElementById("pointsLeft").innerHTML) > 0) {
    session.signal(
      {
        data: totalSessions[0].connection.connectionId,
        type: "voteSpeakerOne"
      },
      function(error) {
        if (error) {
          alert(error.message);
        }
      }
    );
    decrementVote();
  }
});

$('#speakerTwoPoints').click(function() {
  if (parseInt(document.getElementById("pointsLeft").innerHTML) > 0) {
    session.signal(
      {
        data:  totalSessions[1].connection.connectionId,
        type: "voteSpeakerTwo"
      },
      function(error) {
        if (error) {
          alert(error.message);
        }
      }
    );
    decrementVote();
  }
});

// LISTENER EVENTS

session.on(
  "signal:decrementVote", function(event) {
    document.getElementById('pointsLeft').innerHTML = event.data;
    votingPoints = votingPoints - 1;
  }
);

// Listener SpeakerOneUpvote
session.on(
  "signal:voteSpeakerOne", function(event) {
    var newPoints = incrementStream(event.data);
    $('#speakerOnePoints').html(newPoints);
  }
);

// Listener SpeakerTwoUpvote

session.on(
  "signal:decrementVote", function(event) {
    document.getElementById("pointsLeft").innerHTML = event.data;
  });
session.on(
  "signal:voteSpeakerTwo", function(event) {
    var newPoints = incrementStream(event.data);
    $('#speakerTwoPoints').html(newPoints);
  }
);

// Stores the points of the connection locally and returns the value
function incrementStream(connectionId) {
  for (var i = 0; i < totalSessions.length; i++) {
    if (String(totalSessions[i].connection.connectionId) == String(connectionId)) {
      var data = totalSessions[i].connection.data.split("|");
      totalSessions[i].connection.data = parseInt(data[0]) + 1 + "|" + data[1];
      return parseInt(data[0]) + 1;
    }
  }
  return 0;
}

// Get whoever connected and add to list
session.on(
  "connectionCreated", function(event) {
    var emailAndPoints = event.connection.data.split("|");

    // JSON points email => Speaker number
    // totalSessions puts people in the right order by speaker number
    totalSessions[parseInt(debatersJson[emailAndPoints[1]])] = event;
  }
);

// Listen to ourselves if we lose
session.on(
  "signal:disconnect", function(event) {
    if (session.connection.connectionId == event.data) {
      session.unpublish(publisher);
    }
  });

session.on(
  "signal:decrementClock", function(event) {
    var currentTime = $('#clock');
    currentTime.html(event.data);
});

session.on(
  "signal:resetTimer", function(event) {
  $('#clock').html("10");
});

session.on(
  "signal:adjustAudio", function(event) {
    if (event.data == session.connection.connectionId) {
      alert("your turn to speak");
      publisher.publishAudio(true);
    }
    else {
      publisher.publishAudio(false);
    }
  }
);

session.on(
  "signal:nextRound", function(event) {
    var currentRound = $('#roundNumber');
    currentRound.html(event.data);
  }
);

session.on(
  "signal:removeButtons", function(event) {
    var myIndex = parseInt(debatersJson[myEmail]);
    $('button.OT_edge-bar-item.OT_mute.OT_mode-auto').each(function(index) {
      if (myIndex == index) {
        $(this).hide();
      }
    });
  }
);

session.on(
  "signal:unmuteAll", function(event) {
    publisher.publishAudio(true);
  }
);
