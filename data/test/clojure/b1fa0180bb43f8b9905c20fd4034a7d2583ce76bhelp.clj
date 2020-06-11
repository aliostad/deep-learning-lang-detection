(ns cadejo.ui.util.help)


(declare display-topic)
(def ^:private docs* (atom {}))


(defn help-action [ev]
  (let [src (.getSource ev)
        topic (.getClientProperty src :topic)]
    (display-topic topic)))
  

(defn display-topic [topic]
  (let [text (get @docs* topic "Help Not Available")]
    (println (format "--------------------------------------------- %s" topic))
    (println text)
    (println)))
    


;;;; Temp on-line documentation

(defn- add-topic [topic text]
  (swap! docs* (fn [q](assoc q topic text))))


(add-topic :cadejo
"Cadejo is a MIDI management tool and collection of instruments for
Overtone. Broadly Cadejo may be viewed as two separate but
interdependent sections. As a MIDI tool Cadejo provides an unified
infrastructure for processing MIDI messages for Overtone instruments; in
short Plumbing. Cadejo MIDI management takes care of channel assignments,
voice allocation in response to key events, mapping for velocity, pressure,
pitch bend and continuous controller events. All MIDI channel messages are
supported with the exception of polyphonic after-touch.  It is possible to
define arbitrary layers, key splits and alternate tuning.

The second major area of Cadejo is as an open collection of
instruments. Initially 4 instruments are provided:

    Combo - a simple ‘combo’ organ
    MASA - a more complex organ loosely based on the Hammond B3
    Algo - an 8-operator FM synth
    Alias - a mono 'matrix-synth' with extensive modulation possibilities.
    Cobalt - a hybrid additive/subtractive synth

     *** Trees, Nodes and Properties ***

Cadejo is organized in a hierarchical tree structure. Incoming MIDI
messages are passed from parent to child nodes with possible processing
along the way. At the top of each Cadejo tree is a node called a
'scene'. The scene establishes default values and also defines which
alternate tuning tables are available. Beneath each scene are 16 MIDI
channel objects. As expected these objects process message for specific
channels. In turn each channel may have 0 or more child nodes called
'performances'.  Each performance is associated with a single Overtone
instrument. Performances are so closely tied with the instrument they
contain that the terms 'performance' and 'instrument' are often used
interchangeably, though technically they are not the same thing.

Each node has a set of properties which dictate how specific MIDI messages
are treated. If a node does not define a property then it automatically
inherits the property from it’s parent. For a specific example consider the
‘transpose’ property which adds a fixed value to incoming MIDI key numbers.  

The transpose property for scene objects has the value 0. Since a scene is
at the root of each Cadejo tree and nodes inherit properties from their
parent, all nodes automatically also has a transpose value of 0. However a node
is free to define it’s own local value for any property which then replaces
the parent’s value. If channel 3 has a transpose value of 12 then all notes
on channel 3 are transposed up an octave regardless of the transpose value
at the scene level. Likewise a performance may define its own value for
transpose which is then used instead of channel transpose. The following
properties are defined:
 
    :bend-curve     - keyword, mapping function id
    :bend-range     - integer, bend range in cents
    :dbscale        - integer, amplitude scale in db
    :key-range      - pair [low high], 
    :pressure-bias  - float, value added to MIDI pressure
    :pressure-curve - keyword, mapping function id
    :pressure-scale - float, value multiplied by pressure
    :scale-id       - keyword, tuning table selection
    :transpose      - integer, key-number transpose
    :velocity-map   - keyword, mapping function id

              *** Quick Start Guide ***

1) Start SuperCollider server
   
   Cadejo initially displays a splash screen with options to start a
   SuperCollider server for Overtone. Select a server from the options on
   the left and click the large 'Start Server' button. After the server
   starts the screen automatically switches to the scene selection page. If
   a running server is detected when Cadejo boots the server selection
   screen is skipped.

2) Select MIDI device and create Scene

   After the server starts the splash screen switches to the Scene
   creation page where an input MIDI device is selected and scene objects
   are created.  Select the desired MIDI device from the available options
   on the left and click the large 'Create Scene' button.  After a moment a
   window appears for the new scene.

   It is worth taking a moment to examine this window as most of the
   remaining Cadejo windows have the same general layout.

   The top row contains a large label on the left which identifies the
   specific Cadejo node. To the right of this label are at least two
   buttons. The button with a tree graphic and an up-arrow takes you back
   to the parent node, in this case the initial splash screen.

   Immediately below the top toolbar are a set of tabs. The exact function
   of these tabs varies depending on the node type. For scene objects there
   are two tabs: one to display the current tree configuration, and the
   other to edit the 'scale registry' for alternate tuning tables.  The
   large central area below the tab buttons is reserved for the tab
   contents.

   Below the center window is a set of buttons to access child nodes. In
   the case of a Scene the child nodes correspond to the 16 MIDI
   channels. For other node types there may be any number of child nodes
   including zero.

   At the bottom of the window are status and info lines. 

3) Select MIDI channel. 
   
   Click one of the channel buttons from the bottom of the Scene window and
   after a moment a new window appears for the selected channel. Channel
   windows have two tabs and initially no child nodes. The left-most tab,
   with guitar icon, is used to add instruments to the channel. The second
   tab, with MIDI plug icon, is used for setting channel level MIDI
   properties.

   The most obvious feature of the channel window are the large icons under
   the add-instrument tab. Clicking one of these icons brings up an
   'add-instrument' dialog used to add instruments to the channel.

   After the new instrument is created it appears at the bottom of the
   Channel window with a smaller version of the instrument's icon. Within
   reason any number of instruments may be added to the same channel
   including multiple copies of the same instrument. The only restriction
   is that each instrument instance have an unique id.

4) View/edit performance.

   Click one of the smaller instrument icon created above to view it's
   performance window. 

   The general layout of performance windows is that same as for scene and
   channel windows and has at least two tabs. The left most tab is for the
   program bank (see below). The second tab is for general MIDI parameters
   and has the same functionality as the channel MIDI tab. There may be one
   or more additional MIDI tabs for mapping MIDI continuous controller
   events. The exact number of additional tabs depends on the specific
   controllers the instrument supports.

5) Program banks.

   The left most tab of the performance window accesses the program
   bank. Each program bank has it's own toolbar and is dominated by a list
   of up to 128 programs.  The toolbar icons (from left to right) are

      1. Initialize - Clear bank contents
      2. Edit name - Set bank name and remarks
      3. Open bank file
      4. Save bank file
      5. Undo 
      6. Redo
      7. Edit Program (see below)
      8. Transmit current voice
      9. Help

6) Program Editor

   The program editor window again has the same general form as the other
   windows.  By it's nature however the program editor has the most varied
   content. The top toolbar is now extended with the following options
   (from left to right)

      1. Show parent window (in this case the Performance)
      2. Open program file
      3. Save program file
      4. Copy program to clipboard
      5. Paste clipboard to current program
      6. Help

   The content and number of program editor tabs is dependent on the
   specific instrument. The left-most tab however is common to all program
   editors and is used to set the program's name and optional remarks
   text. 

   At the bottom left of the program editor are two buttons. The left most
   button resets the current program to an initial program. The second
   button produces a random program. 

   The elements at the bottom right of the program editor are used to save
   the current program into the bank. The numeric display shows the bank
   slot where the program is to be saved. The single and double up/down
   buttons increment/decrement the program number by 1 and 8 respectively.
   The right most button does the actual dead of storing the
   program. Edited programs will be lost unless they are either saved to a
   file or stored in the bank. Likewise changes to the bank will be lost
   unless saved to an external file.

   The very bottom of the program editor contains the expected info lines.")


(add-topic :scene
"At the root of each Cadejo tree is a 'Scene'. Each scene responds to
events from a single MIDI device and serves two primary functions. Scenes
define default property values and also provide a 'scale-registry' for
alternate tuning. 

The scene property values are intended as reasonable defaults and are
not editable by the user. 

With just two tabs the Scene window is perhaps the simplest in Cadejo. The
left most tab is informational only and displays a graphical representation
of the current Cadejo tree. The second tab is for the 'scale-registry'
which has it's own dedicated help section. 

The bottom of the Scene window contains buttons to access the 16 MIDI
channels.  An asterisk appearing next to a channel number indicates that
channel has one or more active instruments.")

(add-topic :channel
"Channel objects occupy a middle position within a Cadejo tree. Each channel
has a Scene object as parent and zero or more performance or instrument
children. The primary responsibility of channel objects is to aggregate
collections of instruments for layering and key-splits and to provide
channel-level MIDI event mapping. 

The channel window contains two tabs. The left most tab is used to add
instruments to the channel. Clicking one of the large instrument icons
brings up a dialog to add that instrument to the channel. Once an
instrument is added it appears as a smaller icon at the bottom of the
channel window. An instrument may be removed from a channel by clicking on
it's icon while pressing the shift key. Note there is a minor refresh
bug. The icon for an instrument which has been removed from a channel may
continue to be displayed in the channel window. You can force a refresh by
resizing the channel window.

The second tab in the channel window sets MIDI mapping properties for the
channel. This tab contains three nearly identical sections for bend,
pressure and velocity and a fourth section on the right for various other
properties. 

Mapping curves:

    The bend, pressure and velocity sections each contain buttons to select
    one of 19 mapping functions. The maps on the top row return constant
    values of off, half-on and full-on respectively. The next three rows
    contain positive linear, exponential, convex and s-shaped maps of
    various degree. The final three rows contain inverted versions of the
    above. 

Enable box

   A note on the enable check boxes. Each mapping section contains an
   'enable' checkbox. This is a bit of a misnomer as the various MIDI
   messages are **always** 'enabled'. Instead what these check boxes
   indicate is that the specific property is to be used instead of value
   established by the parent. If velocity is 'enabled' at the channel level
   then the velocity properties of the parent scene are ignored. 

Bend 
   
    Pitch bend is specified in cents as indicated by the spinner at the
    bottom of the bend area. The up and down spinner arrows
    increment/decrement the bend range by a single cent. The '++' and '--' 
    buttons increment/decrement bend range by 100 cents (1/2 step).

Pressure

    Pressure has two additional parameters for 'scale' and 'bias'. After the
    pressure mapping function is applied the pressure is multiplied by
    scale and then added to the bias value.  Note that in most cases Cadejo
    'normalizes' incoming MIDI data to a range of (0.0 1.0).

Velocity

    Sets velocity mapping curve.

DB Scale

    Amplify/attenuate instruments on this channel

Transpose

    Add fixed value to incoming MIDI key numbers. Transpose is **prior** to
    tuning-table mapping. For the default tuning table transpose does what
    you expect.

Key Range

    The key range property sets the range of keys to which this channel
    responds. Key range is checked **prior** to addition of the transpose
    value.

Scale

   Selects the tuning table, see scale-registry documentation. The default
  :eq-12 is the standard Western 12-note equal tempered scale with A=400.")

(add-topic :scale-registry
"A tuning-table is a map between MIDI key numbers and frequency. Strictly
speaking a 'tuning-table' and a 'scale' are not the same thing though the
two terms are often used interchangeably. Usually a tuning-table contains a
single scale but may in fact contain multiple scales. 

Each scene object contains a 'scale-registry' which defines the set of available
tuning-tables. By default all scale registries contain a table called
:eq-12 which defines the standard Western 12-tone scale tuned to A440.  The
scale-registry contains a toolbar at the top, a list of available scales on
the left, a set of 'range' spinners immedialty to the left of the scale
list and scale creation and editing areas further left. 

From left to right the scale registry toolbar buttons are:
   
   1. Initialize registry to default
   2. Open registry file
   3. Save registry file
   4. Undo
   5. Redo
   6. Remove table
   7. Add table
   8. Edit existing table
   9. Detail table editor (not implemented)
  10. Help

Add scale

   The 'Add' tab contains two fields at top, scale-id and Tune A440, above
   three sections labeled 'blank' 'just' and 'Equal Temp'

   Within the registry each table must have a unique ID. The Scale ID field
   is automatically 'validated' and will have an alarming background color
   if the entered id is invalid for some reason.  There are three general
   types of scale which may be added to the registry: blank, just and
   eq-temp.

Edit table

   The 'edit' tab provides methods to alter and combine existing tables. 
   The editing functions apply to the currently selected table in table
   list and operate over the range of keys displayed in the low and high
   key range spinners.

   Linear
       
      initial - reset fields to default
     
      linear - Set table values over selected key range to linear values
      between f1 and f2.

      invert - Reverse table values over selected range

   Transpose

      Transpose table values over selected range by steps+cents amount, add
      fixed value to each key. 

   Splice

      Copy portion of source table into destination table over selected key
      range. Source and destination tables are selected by clicking the
      table list. The location value sets the key-number in the destination
      table where the copied values are placed.")

(add-topic :add-instrument
"The 'Add Instrument' dialog is used to add instruments/performances to a
specific MIDI channel. As long as the dialog is visible all other Cadejo
windows are disabled. The dialog provides the following options:

   key mode
      Selects if this instrument is to be mono or polyphonic. Note not
      all instruments support polyphonic mode.

   Output bus
      The SuperCollider audio bus this instrument sends output to, The
      default bus of 0 corresponds to the default sound card output

   Voice count
      The maximum number of voices, default 8, Voice count is ignored for
      mono key mode.

   Controllers
      MIDI continuous controller assignment. The number of controllers is
      dependent on the specific instrument. 

   Instrument ID
      Each instrument **MUST** have a unique id on any given channel. An
      unused default ID is automatically generated but may be changed if
      desired.")

(add-topic :combo
"Combo is a simple organ mostly used as a development test bed. It has a
simple voice structure of 4 tones which are mixed and sent to a
non-resonant tracking filter. Effects include a flanger and reverb

Each tone has two sliders for mix (top) and wave (bottom). Tones 1 and 2
produce square/pules waves while tones 3 and 4 use FM feedback to produce
sine waves (no feedback), sawtooth waves (higher feedback), or FM
noise. The frequency relationship between the 4 tones is 1:2:3:4 but may be
altered in-mass by the 'detune' slider.

The filter section consist of two sets of buttons. The top buttons select
one of five filter curves (bypass, low-pass, high-pass, band-pass and
notch). The bottom buttons select the harmonic of the cutoff or center
frequency. 

The remaining controls effect vibrato, reverb, flanger and overall output
amplitude.")

(add-topic :masa
"MASA is an organ loosely based on the Hammond B3. The MASA editor contains
3 tabs: Registration, Gamut and EFX

Registration

   The registration tab controls the relative amplitudes and envelopes of
   the 9 component partials which comprise a MASA tone. Each partial has an
   'Amp' and 'Pedal' sliders and 'Perc' button. The amp sliders have a
   range between 0 (off) and 8 (full on). The pedal sliders have a range
   between -8 and +8 and set how each partial is effected by changes in the
   MIDI pedal controller. The pedal values are additive to the amp values
   but the over all partial amplitude never exceed 8. If a partial has an
   amplitude of 8 and a positive pedal value then movement of the pedal
   will have no effect on the partials amplitude. 

   The final partial control is the 'perc' or percussion button. If
   selected percussion changes the partial envelope from a gated contour to
   a percussive one. The percussion decay time and sustain level is set by
   the two sliders on the upper right hand side. 

   The remaining controls on the lower right hand side of the registration
   tab adjust vibrato parameters. 

Gamut

   The gamut tab sets the frequency relationship between the
   partials. Frequencies may be set directly as harmonic/detune
   values for each of the 9 partials or they may be set in-mass by one of
   the preset buttons on the right hand side.

Effects

   MASA has two effects, a reverb and a unique 'scanner' vibrato")

(add-topic :algo
"Algo is an 8 operator FM synthesizer with a fixed 'algorithm'. The algo
editor has four tabs: FM, AM, Env and Efx.

FM tab
    
    The FM page shows the frequencies and output amplitudes of each
    operator. The frequency component has two values, 'freq' and
    'bias'. The freq parameter sets the operator frequency relative to the
    note frequency. IE if the played note is A440 and the freq value is 2,
    the operator frequency will be 880. The bias parameter adds a fixed
    value to the frequency.  To select a parameter to edit click the button
    to it's left. The key pad above operator 8 is used to edit values of
    the selected parameter.

AM tab 

    The AM page sets amplitude modulation parameters for each
    operator. Operator amplitude may be modified by velocity, pressure,
    LFO1, LFO2 or MIDI controllers A and B. The operator keyscale
    parameters adjust how an operators amplitude scales above and below key
    break points. For example is the left key is set to 60 and left scale
    is 6 the the operator increases 6db for each octave below key 60.

Envelope tab

    Each operator has an ADDSR style envelope. The buttons below the
    envelope display have the following functions (from left to right)

    1) invert -  (not all operators may be inverted)
    2) reset - Set envelope to a 'gated' shape
    3) copy - copy envelope to the clipboard
    4) paste - paste envelope from clipboard
    5) zoom-in - 
    6) zoom-out
    7) restore to default zoom

Operator mute buttons

    At the bottom of the FM, AM and envelope pages are 8 buttons used to
    mute or enable specific operators.

Fx tab

    The Fx page contains controls for feedback (operators 6 and 8), the
    three LFO's, a delay line, reverb and output filter.")

(add-topic :alias
"Alias is a monophonic subtractive synth with extensive modulation
possibilities. The audio path begins with 3 oscillators, a noise source and
ring-modulator. These signals are mixed and fed to one of two filter
paths. The two filters have different qualities and both include integral
waveshapers. An amplitude envelope is applied to the filter outputs which
are then sent to the effects section. For effects Alias includes parallel
pitch-shifter, flanger and two delay lines. At the heart of Alias is a
control matrix and virtually every major parameter may be modified by one
of the matrix buses.   The control sources include three envelopes, three
LFOs, two step counters, two frequency dividers, sample and hold,
low-frequency noise source, MIDI pressure, velocity, key frequency and 4
MIDI continuous controllers. All this combines to make Alias a very complex
instrument which at times is hard to understand, but that's half the fun

The Alias editor contains 7 tabs

   1) oscillators, noise source and ring-modulator
   2) Mixer
   3) Filters and effects
   4) Envelopes
   5) LFOs, sample-and-hold, low-frequency noise
   6) Step counters and dividers
   7) Matrix")

(add-topic :alias-osc
"Alias uses three oscillators which have identical controls but produce
different wave-shapes. OSC 1 produces a 'synced' sawtooth wave. Note that
OSC is not band-limited so aliasing may be expected, particularly at higher
frequencies.  OSC2 produces pulse waves with pulse width modulation. OSC3
uses FM feedback and may produce anything from sine waves to saw like waves
to FM noise.

Each oscillator panel is dominated by 2 numeric displays for control of
detune and frequency bias values, The three tiny buttons to the left of
these displays are used to initialize or randomize the oscillator's
values. 

The panel immedialty below the numeric displays control frequency
modulation. Each oscillator may have up to 2 FM sources and each source has
3 sliders. The 'bus' slider selects the FM source via one of the 8 matrix
buses (A-H). The two sources labeled '1' and '0' at the top and bottom of
the bus slider respectively provide constant values. Each FM source has a
depth slider which sets how deep the control signal modulates the
frequency. Both positive and negative depths present. The final 'lag'
slider imparts a time-delay and smoothing function to the control
signal. Bus A serves as the de facto bus for vibrato via LFO1 and the MIDI
modulation wheel. 

As expected the 'Wave' panel controls oscillator timbre. There is a fixed
wave value and up to 2 modulation sources. 

The AM panel controls oscillator amplitude, again with a fixed 'amp' slider
(in db) and up to 2 modulation sources. NOTE: the two AM modulation sources are
multiplied. This means that if either AM bus slider is set to the '0'
position the oscillator will not produce sound. Unused AM buses should be
placed in the '1' position.

The horizontal slider at the bottom of each oscillator panel sets how much
of the oscillator's output is sent to each of the two filters. The overall
oscillator amplitude and pan sliders are duplicated on the mixer tab.")

(add-topic :alias-noise
"The Alias noise source uses the 'crackle' u-gen and has integrated low and
high pass filters. Noise amplitude may be modulated by up to 2 modulation
sources and unused modulators should be set to bus '1'. The overall
amplitude and pan sliders are duplicated on the mixer tab")

(add-topic :alias-ringmod
"The carrier input to the Alias ring-modulator is from a mixture of OSC1 or
OSC2.  Modulation input is provided by a mixture of OSC3 and the noise
source. Up to 2 modulators may be applied to the ring-modulators
amplitude. Any unused modulator should be set to bus '1'.  The overall
amplitude and pan sliders are duplicated on the mixer tab")

(add-topic :alias-mixer
"The mixer is a convenience tab which groups similar sliders in a single
location. All of the mixer sliders are duplicated in other locations
throughout the Alias editor. The mixer is divided into three sections;
filter input, filter output, and Effects. Each of these groups have
amplitude sliders in the top row with corresponding pan sliders in the
second row. 

The bottom row of the mixer tab contains misc sliders which appear here for
lack of a better place. These include portemento time, MIDI volume control
depth and over all amplitude")

(add-topic :alias-filter
"Alias contains two filter paths, each with an integral
waveshaper. These two paths are not identical, both the filters and 
waveshapers are unique to each path. Despite being different filters the two
paths have nearly identical controls.

Distortion (Waveshaper)

   The waveshapers are applied to the signal prior to entering the
   filters. Both waveshapers have the property that the overall output
   amplitude never exceeds unity despite the input amplitude.  The
   waveshapers have the following controls

   1) Pregain - Amount of gain, in db, applied to signal before the
      waveshaper.
   2) Clip - The clipping amount
   3) Bus - The clipping amount may be modulated by a single matrix source 
   4) Depth - Amount of modulation applied
   5) Mix - Wet/dry mix of original signal and waveshaper signal

Filters

   Filter 1 is multi-modal with a continuously variable form between low-pass
   low*high, high-pass and Band. The low*high mode is a ring modulation of
   the low and high pass signals

   Filter 2 is a simulated Moog low-pass filter.

   With exception of the mode slider for filter 1 the two filters have
   identical controls.  Filter frequency is set by the large numeric
   display and up to two modulation sources may be applied to
   frequency. Resonance may also be modulated by a single modulation
   source. 

   The filter outputs feed stereo inputs in the effects section and the pan
   position may have both a static value or b modulated by a single matrix
   control bus. 

Effects

   Alias contains four effects which are each stereo and connected in
   parallel. Matrix bus modulation may be applied to the pitch-shifter
   'ratio' and the flanger delay parameters. The two delay lines may each
   provide up to one second delay and both delay time and delay output may
   be modulated by the matrix.")

(add-topic :alias-matrix
"The Alias matrix tab contains two matrix displays. Source signals are
listed vertically (rows) on the right hand side. Destinations (columns) are
listed across the top. Each column contains one or two 'pins'. To connect
a column to a row click and drag a pin to the intersection of the two. The
'primary' pin for each row has a circle shape. The shape of the second pin
(if there is one) indicates how the two connections interact. If the
secondary pin is a cross '+', the two source signals are summed. If the
secondary pin is an 'x', the source signals are multiplied. Any unused 'x'
pin should be placed in the 'on' row. If an X pin is placed in the 'off'
row then the signal presented to the destination will be 0. 

There are 8 general purpose buses labeled 'A' through 'H'

The larger top matrix is for routing signals between the various control
elements (envelopes, LFOs etc) and also for routing control signals to the
8 general buses  

The lower matrix is for routing signals from the 8 general buses to the
various audio parameters.")

(add-topic :alias-envelope
"Alias contains three identical 5-stage envelopes. Each envelope appears as
a source for the control matrix. Envelope 3 is also dedicated to overall
amplitude. 

At the left hand side of the envelope tab are four vertical buttons. The
top button displays this help message. The remaining three buttons control
the zoom level for the envelope displays. The envelope graphs may be zoomed
in or out to any level The very bottom zoom button resets to the default
zoom of 8 seconds. The number immedialty below this button indicates the
duration of the current zoom level. The vertical graph line indicates the
position of 0 time, which tends to shift as the zoom level changes. 

The dashed envelope segment represents the indeterminate sustain time. To
the right of each envelope graph are four buttons used to reset the graph
to default, randomize the envelope and copy and paste the envelope to the
clipboard.")

   
(add-topic :cobalt
"Cobalt is a hybrid instrument utilizing additive, fm and subtractive
techniques. The instrument contains 6 FM pairs, a tuned noise source, a
pulse generator, two filters, clipper, and two delay lines. Control
elements consist of 4 sine wave LFOs (one general, one vibrato and two for
effects), 13 envelopes (1 each for 6 operators, noise, pulse, filter,
effects and pitch), and external MIDI controllers.


-------------------------------------------------------------------------
Operators

The 6 operators are identical and consist of a single FM carrier/modulator
pairs.  Parameters include

Freq      - Relative frequency
P.Env     - Pitch envelope amount
Amp       - Linear amplitude 
Amp LFO1  - LFO1 amp mod depth
Amp Vel   - Velocity amp mod depth
Amp Prss  - Key pressure (aftertouch) amp mod depth
Amp CCA   - MIDI controller A amp mod depth
Amp CCB   - MIDI controller B amp mod depth
Amp Key   - Keyscale key, (C1, C2, C3, .... C6)
Amp Left  - Left amp keyscale db/octave (-12db ... +12db) in 3db steps
Amp Right - Right amp keyscale
FM Freq   - FM modulator frequency relative to carrier frequency
FM Bias   - Fixed value added to FM frequency
FM Depth  - FM modulation depth
FM Env    - Envelope applied to FM depth. Each operator has a
            envelope generator which is shared by the carrier and
            modulator. The FM Env control sets how much effect the envelope
            has on FM depth. If FM Env is set to 0 the depth will be static.
FM Lag    - The FM envelope lag processor is used to delay/smooth the
            envelope applied to the modulation depth. 
FM Left   - Modulation depth left key scale. The modulator uses the same key
            as the carrier
FM Right  - Modulation right keyscale
Env Att   - Envelope attack time
Env Dcy1  - Envelope initial decay time
Env Dcy2  - Envelope second decay time
Env Rel   - Envelope release time
Env Peak  - Envelope peak value sets the level between the attack stage and
            decay1 stage.
Env BP    - Envelope breakpoint sets the level between the decay1 and
            decay2 stages
Env Sus   - Envelope sustain level sets the level after the decay2 stage
Env Scale - The envelope scale button changes the maximum value of the time
            sliders. 

-------------------------------------------------------------------------
Tuned Noise source

The noise generator produces two tuned noise signals with variable
frequency and band widths.  With exception of frequency, amp and band width
the two signals share all other parameters.  The available noise parameters
are identical to those of the 6 FM operators minus the FM values and CCB
amplitude control. Unique to the noise generator are the band width and lag
controls.

noise bw1  - Band width in HZ of signal 1
noise bw2  - Band width signal 2
noise lag2 - Lag applied to noise 2 envelope

At low band width values the noise signals are quasi tonal with definite
pitch and an airy sound. 

-------------------------------------------------------------------------
Buzz (Pulse) generator 

The buzz generator produces pulse waves with n equal amplitude
harmonics. Like the noise source, the buzz generator shares most of the
same parameters as the FM operators minus the FM values. 

Harmonics N    - Initial number of harmonics
Harmonics Env  - Envelope applied to harmonic count
Harmonics CCA  - MIDI controller A applied to harmonic count
HighPass Track - Highpass filter key track 
HighPass Env   - Envelope applied to highpass filter

-------------------------------------------------------------------------
Filters

Cobalt uses two filters; one low-pass and one band-pass. The filters share
most of same parameters and always track in parallel.

Freq       - Lowpass frequency
Freq Track - Filter keytrack amount
Freq Env   - Envelope applied to frequency
Freq Prss  - MIDI pressure applied to frequency
Freq CCA   - MIDI controller A applied to frequency
Freq CCB   - MIDI controller B applied to frequency
Res        - Resonance
Res CCA    - MIDI controller A applied to resonance
Res CCB    - MIDI controller A applied to resonance
BP Offset  - Bandpass offset relative to lowpass filter
BP Lag     - Amount of lag applied to band pass freq changes
BP Mix     - Mix between two filters.
Env Att    - The filter uses simpler ADSR style envelope
Env Dcy
Env Rel
Env Sus

Distortion is post filter and achieved using signal folding. 

dist Gain - gain applied to signal pre filter, in effect distortion amount 
dist CCA  - MIDI controller A applied to distortion mix
dist CCB  - MIDI controller B applied to distortion mix
dist Mix  - Wet/dry distortion mix. 

-------------------------------------------------------------------------
Vibrato

The vibrato tab contains misc control elements.

Port time - Portamento time
Port CC5  - MIDI CC5 applied to port time

Vib Freq  - Vibrato frequency
Vib Sens  - Vibrato sensitivity
Vib Prss  - MIDI pressure applied to vibrato depth
Vib Bleed - Minimum amount of vibrato signal
Vib Delay - Delay time applied to bleed signal onset.

LFO1 Freq
LFO1 Prss
LFO1 CCA
LFO1 Bleed
LFO1 Delay 

The Pitch Envelope has 4 stages with levels L0 L1 l2 and L3 and times T1 T2
and T3. Levels are bipolar.

-------------------------------------------------------------------------
Effects

The effects section contains 2 delay lines, 2 LFOs and an ADDSR envelope. 
The LFO and envelope may be applied to delay time, amplitude and pan."
)
