import 'dart:html';
import 'dart:math';

// At the end of the file there are some code hints you may find useful.
// Comment format:
//#BEGIN ... //#END - a block of similar things to help you organise this file
//HINT: Something right at this moment I consider a good thing...
//TODO: A Something for you to to do
//NOTE: Extra information or something to look out for in the future.

//#BEGIN: Constants region
const num TAU = 2.0 * PI;
const num TAU_QUARTER = TAU * 0.25;
const num TO_RADIANS = PI / 180.0;

// Invalid for numbers that are expected to be more or equal to zero.
const num _INVALID = -1.0;
//#END:   Constants region

//#BEGIN: Globals region
/// Cleared using this background colour
const String backgroundColour = "rgba(255,243,228,1)";

/// Canvas rendering context
CanvasRenderingContext2D context;

/// Calculated fps for current frame
num fps = -1;

/// Averaged fps
num fpsAverage = _INVALID;

/// Flags that the fps should be drawn
bool isFpsShown = true;

/// Last time stamp from requestAnimationFrame
num lastTimestamp = _INVALID;

/// Top left x position of the central canvas area
num mainAreaX = 0.0;

/// Top left y position of the central canvas area
num mainAreaY = 0.0;

/// Bottom right x position of the central canvas area
num mainAreaX2 = 0.0;

/// Bottom right y position of the central canvas area
num mainAreaY2 = 0.0;

/// Canvas rendering too
CanvasElement playArea;

/// Current play area height. Used by _resize.
num playAreaHeight = window.innerHeight;

/// Element that contains the canvas element
HtmlElement playAreaParent;

/// Current play area width. Used by _resize.
num playAreaWidth = window.innerWidth;

/// Last millisecondsSinceEpoch when a frame was updated
num renderTime = _INVALID;
//#END:   Globals region

//#BEGIN: Public functions region
void main() {
  playArea = querySelector("#playArea");
  playAreaParent = playArea.parent;
  context = playArea.getContext("2d");

  // Setup any events we want to listen too
  window.onResize.listen(_resizedWindow);

  // Call resize initially to setup all the size variables with initial size.
  _resize(window.innerWidth, window.innerHeight);
  _restart();

  window.requestAnimationFrame(_updateFirstTime);
}

/// Called last by _update to draw the current state of the scene
void _draw(num frameTimestamp, num dt) {
  // Clear background
  context.fillStyle = backgroundColour;
  context.fillRect(0, 0, playAreaWidth, playAreaHeight);

  //TODO: Your stuff
  //HINT: Try not to do to many context save and restores. Figure out other ways
  //HINT: Try not to change context state when you don't need too. If you can group things that share states you'll get perf benefits.

  // Render fps last if shown
  if (isFpsShown) {
    context.fillStyle = "#000000";
    context.fillText("FPS Avg ${fpsAverage.round()}",10, 10);
  }
}

/// Used by update first frame. Do not get too fancy!
void _drawBackground(num frameTimestamp, num dt) {
  context.fillStyle = backgroundColour;
  context.fillRect(0, 0, playAreaWidth, playAreaHeight);

  //NOTE: If you get fancy you could rewrite this and only draw / clear "dirty" areas
}

/// Mouse click listener
void _mouseClicked(MouseEvent event) {
  var clientRect = playArea.getBoundingClientRect();
  num x = event.client.x - clientRect.left,
    y = event.client.y - clientRect.top;

  _pickInteraction(x, y);
}

/// Expects [x1] and [y1] in terms of canvas x and y
void _pickInteraction(num x1, num y1) {
  //TODO: Your picking function
  //TODO: E.g. go through list of your interactive object positions, testing if
  // ... it is in that objects bounds, then doing something with it.

  //TODO: It is possible that *nothing* is picked and the user just clicked nowhere.
  //HINT: You may reuse this function with other things other than clicks (e.g. picking comes from AI)
}

/// Update anything that is interested in the window size
void _resize(num width, num height) {
  // To letter box you would constrain the width by the height  (or visa-versa)
  playAreaHeight = height;
  playAreaWidth = width; //playAreaHeight * 1.777777777777778;

  if (playAreaHeight < 1.0) playAreaHeight = 1.0;
  if (playAreaWidth < 1.0) playAreaWidth = 1.0;

  // Aesthetically things should appear within the central area
  // Use main area to help you out there
  mainAreaX = playAreaWidth * 0.25;
  mainAreaX2 = playAreaWidth - mainAreaX;

  mainAreaY = playAreaHeight * 0.25;
  mainAreaY2 = playAreaHeight - mainAreaY;

  playArea.width = playAreaWidth;
  playArea.height = playAreaHeight;
}

/// Listens to the window resize event
void _resizedWindow(e) {
  _resize(e.currentTarget.innerWidth, e.currentTarget.innerHeight);
}

/// Resets page to initial state
void _restart() {
  //TODO: E.g. Reset score, clear down states, start again, etc.
}

/// Called every frame to update and draw the scene
///NOTE: This should always return quickly or the browser will:
/// a) Throttle how many times this function get called
/// b) Display a warning about the script being unresponsive
void _update(num frameTimestamp) {
  // May as well put the request for the next update in the queue now.
  window.requestAnimationFrame(_update);

  num time = new DateTime.now().millisecondsSinceEpoch;

  // Update fps
  fps = 1000.0 / (time - renderTime);
  fpsAverage = fps * 0.05 + fpsAverage * 0.95;
  num dt = time - renderTime;

  // If time stamps are identical means we've got a spare frame.
  // No point wasting time though so only render if we have something to do.
  if (frameTimestamp != lastTimestamp) {
    _updateLogic(time, dt);
    _updateAnimations(time, dt);

    _draw(time, dt);
  }

  // Update timing variables for next updates.
  renderTime = time;
  lastTimestamp = frameTimestamp;
}

/// Update any flourishes, lerps etc.
///NOTE: If complex split over multiple frames, avoid hitching
void _updateAnimations(num time, num dt) {
  //TODO: Lerps etc if you need them, delete this function if you do not.
  //HINT: Cache locality matters even in Javascript.
  //HINT: Keep structures iterating over in typed arrays.
  //HINT: Warm up lists upfront to keep instances of things close together.
}

/// Only used on the first frame to draw background
void _updateFirstTime(num frameTimestamp) {
  // May as well put the request for the next update in the queue now.
  window.requestAnimationFrame(_update);

  // Draw first frame as if 1.0 had passed
  // Everything is in their initial positions, no updates
  renderTime = new DateTime.now().millisecondsSinceEpoch;
  _drawBackground(renderTime, 1.0);
  lastTimestamp = frameTimestamp;
}

/// Update player movement, ai. physics, whatever
///NOTE: If complex split logic updates over multiple frames rather than risk hitching
void _updateLogic(num time, num dt) {
  //TODO: Check mouse / key state to see if you need to react to it
  //TODO: Move anything that is reacting in world.  E.g. apply gravity to everything.
}

//#END:   Public functions region


//#BEGIN: Private functions region
//#END:   Private functions region


//HINT: Classes probably deserve to be in their own files... but if you are doing a single file experiment stick them at the end?
//#BEGIN: Classes region
//#END:   Classes region


//-------------------------- HINTS --------------------------//
// ... you may as well delete this entire section ;)
//HINT: Use mainAreaX mainAreaY etc to keep interesting things central.  Think wide-screen vs 4:3 screens - interesting stuff stays in central 4:3 area.

//HINT: For sanity's sake by default keep things in alphabetical order within semantic regions.
// alphabetical order make searching in a large file very predictable

//HINT: If prototyping then always use the simplest thing you can get away with until it starts feeling yucky.
// So do not make a class if a variable will do.
// Create another simple function rather than overloading an existing one.

//HINT: Avoid nulls. Dart and Javascript find it difficult to optimise code paths that use nulls.
//HINT: Avoid closures in code along the critical path. They cause extra lookups and other work.
//HINT: Avoid reusing a variable for different types. E.g. do not assign a String and int to the same object ref just because you can.
//HINT: Avoid optional parameters. Hard for compiler to reason about, plus indicates overloading of responsibility.
//HINT: Reuse instances of variables where you can rather than creating new instances to give garbage collector less work.
//HINT: Things that are allocated close in time tend to be close in space. This helps data locality.
//HINT: Implement things that will always have exactly 1 of something singularly.
//HINT: If the use case is more likely to be 0..* then implement in terms of list.
//HINT: If performance is measurably in a function low try reducing calls to other functions and unrolling loops.
//HINT: Use plain old data (pod) objects where possible.
//HINT: Keep pod objects small and to the point.
//HINT: Avoid bools and flags. Sometimes are necessary, but low information density and implies branching.
//HINT: Layout of pod objects matter. Declare members with predictable size (e.g. int, double) upfront.
//HINT: When you need to work on the plain old data objects try implementing in terms of free functions.
//HINT: When you must have classes with functions, keep them simple.
//HINT: String manipulation is expensive - take care if you are recreating a string per frame
