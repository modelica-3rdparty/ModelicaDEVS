package ModelicaDEVS "Discrete Event Systems Library"
  package UsersGuide "User's Guide"
    annotation (DocumentationClass=true, Documentation(info="<html>
<font color=\"#008000\" size=5><b>Users Guide of the ModelicaDEVS Library</b></font>
<p>
This package contains the <b>User's Guide</b> for
the library and has the following content:
</p>
<ol>
<li>
<a href=\"Modelica://ModelicaDEVS.UsersGuide.Introduction\">
The Introduction</a>
     summarizes the motivation for the ModelicaDEVS library.
</li>
<li>
The second chapter provides a brief introduction into the concepts of the <a href=\"Modelica://ModelicaDEVS.UsersGuide.DEVSformalism\"> DEVS Formalism</a>.
</li>
<li>
The third chapter explains the idea of <a href=\"Modelica://ModelicaDEVS.UsersGuide.QSS\"> Quantised State Systems</a>.
</li>
<li>
The section about <a href=\"Modelica://ModelicaDEVS.UsersGuide.PowerDEVS\"> PowerDEVS</a> shows the simulator concept of PowerDEVS, another DEVS implementation from which the structure for the ModelicaDEVS library has been taken.
</li>
<li>
The <a href=\"Modelica://ModelicaDEVS.UsersGuide.ModelicaDEVS\"> ModelicaDEVS</a> section presents the library - from a more theoretical point of view as well as in terms of a listing of the available components.
</li>
<li><a href=\"Modelica://ModelicaDEVS.UsersGuide.Literature\">Literature</a></li>
</ol>
<br/>
<br/>
<br/>
Remark: most of the provided information is taken from the thesis within the scope of which the ModelicaDEVS library has been written. The complete thesis is available under <a href=\"http://www.inf.ethz.ch/personal/fcellier/MS/MS_index.html\"> http://www.inf.ethz.ch/personal/fcellier/MS/MS_index.html </a>
</html>"));
    package Introduction "Introduction"
    annotation (Documentation(info="<html>
<font color=\"#008000\" size=5><b>Introduction to the ModelicaDEVS Library </b></font>
<p>
The goal of this thesis is to implement a new Dymola/Modelica library, consisting of a number of blocks that enable simulation according to the <a href=\"Modelica://ModelicaDEVS.UsersGuide.DEVSformalism\"> DEVS formalism</a>. The ulterior motive is to provide Dymola with an additional integration method based on the DEVS methodology.
<br/>
<br/>
Dymola/Modelica primarily deals with continuous physical problems, usually described by differential equations. Integration is therefore an important subject and justifies the attempt to improve/enhance Dymola's current possibilities regarding integration methods.
<br/>
<br/>
It may be a bit surprising at a first glance why a methodology such as DEVS, originally designed for discrete systems, should be useful for the simulation of continuous systems.
<br/>
Toward the end of the nineties however, a new approach for numerical integration has been developed by Zeigler et al. [Zeigler98]: given the fact that all computer-based simulations have to undergo a discretisation in one way or another - as digital machines are not able to process raw continuous signals - the basic idea of the new integration approach was to replace the discretisation of time by a discretisation of state, such that the system is not supposed to advance from time step to time step anymore, but rather from state to state. While conventionally the time axis was subdivided into intervals of equal length, the time instants when the system executes the next simulation step are now distributed irregularly because of their dependence on the time instants when the system enters a new state which is not necessarily at equidistant time instants.
<br/>
The DEVS formalism turned out to be particularly suited to implement such a state quantisation approach given that it is not limited to a finite number of system states, in contrast to other discrete-event simulation techniques.
<br/>
The <a href=\"Modelica://ModelicaDEVS.UsersGuide.QSS\">Quantised State Systems</a> introduced by Kofman [Kofman01] in 2001 improved the original quantised state approach of Zeigler, and hence gave rise to efficient DEVS simulation of large and complex systems.
<br/>
<br/>
The simulation of a continuous system by a (discrete) DEVS model comes with several benefits:
<ul>
<li>
Usually, the classic methods use a discretisation of time, which however has the drawback that the variables have to be updated contemporarily. Thus, the time steps have to be chosen according to the variable that changes the fastest, otherwise a change in that variable could be missed. In a large system where probably very slow but also very fast variables are present (many slow and a few fast variables, in the worst case), this is critical to computation time, since the slow variables have to be updated way too often.
<br/>
Note that the need for updating variables contemporarily does not hold for methods with dense output. However, today's integration methods make rarely use of dense output, hence the above statement is true for the majority of used integration methods.
</li>
<li>
The DEVS formalism however allows for asynchronous variable updates, whereby the computational costs can be reduced significantly: every variable updates at its own speed; there is no need anymore for an adaptation to the fastest one in order not to miss important developments between time steps.
<br/>
This property could be extremely useful in stiff systems that exhibit widely spread eigenvalues, i.e., that feature mixed slow and fast variables.
</li>
<li>
The DEVS formalism is very well suited for problems with frequent switching operations such as electrical power systems. Given that the problem of iteration at discontinuities does not apply anymore, it even allows for real-time simulation.
</li>
<li>
For hybrid systems with continuous-time, discrete-time and discrete-events parts, a discrete-event method provides a \"unified simulation framework\": discrete-time methods can be seen as a particular case of discrete-events methods [Kofman01] and continuous-time parts can be transformed straightforwardly to discrete-time/discrete-events systems.
</li>
<li>
When using the Quantised State Systems approach of Kofman in order to transform a continuous system into a discrete system, there exists a closed formula for the global error bound [Cellier05], which allows a mathematical analysis of the simulation.
</li>
</ul>
Since the mid seventies, when Zeigler introduced the DEVS formalism [Zeigler76], there have emerged several DEVS implementations, most of them designed to simulate <b>discrete</b> systems. However, one simulation/modelling software systems that is aimed at simulating <b>continuous</b> systems, is <a href=\"Modelica://ModelicaDEVS.UsersGuide.PowerDEVS\">PowerDEVS</a>: it provides the components for modelling the block diagram representation of any system described by DAE's.
<br/>
Given the fact that the implementation of the PowerDEVS functionality in Modelica perfectly matches our goal of providing Dymola with an additional simulation method for continuous systems, ModelicaDEVS is developed as closely as possible to PowerDEVS.
<br/>
<br/>
Although <a href=\"Modelica://ModelicaDEVS.UsersGuide.ModelicaDEVS\">ModelicaDEVS</a> is primarily an attempt at enhancing Dymola's integration competences by the benefits of DEVS integration using the synchronous information flow principle of the programming language Modelica, the new library can of course also be used for common discrete-event simulations that do not need to integrate anything.
</p>
<br/>
<br/>
</html>"));
    end Introduction;

    package DEVSformalism "The DEVS Formalism"
    annotation (Documentation(info="<html>
<font color=\"#008000\" size=5><b>The DEVS Formalism</b></font>
<p>
The origins of the DEVS formalism, ascribable to Bernard Zeigler, are rooted back in the mid seventies (1976). Because of Zeigler's interest in the continuous simulation of systems with frequent discontinuities [Cellier05] one of this new formalism's main purposes were to provide a common framework for continuous as well as for discrete-event models.
<br/>
The DEVS formalism was among the first discrete systems theories with a mathematical background: while before the advent of the computer, continuous systems were mostly described by differential equations, with the growing computational power of computers discrete-event simulations were made possible but usually lacked a profound mathematical theory. Only roughly since the early seventies, it was recognized that deeper, i.e. mathematical, understanding of complex systems can help their efficient simulation, and research in this area began to be carried out. The DEVS formalism was one of the resulting mathematically well-founded methodologies in the area of discrete-event systems simulation.
<br/>
<br/>
During the past years, several implementations of the theoretical concept defined by the DEVS formalism have emerged (see the introductory part of [Kofman03] for examples), among which also <a href=\"Modelica://ModelicaDEVS.UsersGuide.PowerDEVS\">PowerDEVS</a> [Kofman03].
<br/>
<br/>
The next two sections will discuss the theory of the DEVS formalism as it has been defined by Zeigler. The first section covers the topic of atomic models which actually reveals the fundamental principles of the formalism. The second section discusses an \"extension\" of these ideas, namely a) the possibility of linking models to each others such that they form a coupled (multi-component) system and b) the hierarchic use of a coupled model as a component of another coupled model.
<br/>
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>Atomic Models</b></font>
<br/>
<br/>
A DEVS model has the following structure (see also [Cellier05], Chapter 11):
<centering>M=(X,Y,S, dint(s), dext(s,e,x), &lambda;(s), ta(s))<centering>
where the variables have the following meaning:
<ul>
<li>
X represents all possible inputs, Y represents the outputs and S is the set of states.
</li>
<li>
The variable e (used within the dext function) indicates the amount of time the system has already been in the current state.
</li>
<li>
dext(s,e,x) is the external transition which is executed after having received an external event.
<br/>
As an example, assume the system adopted state 6 at time t=7.5 and it receives an external event with the value 3.33 at time t=9. Then, the new state is computed by s<sub>new</sub>=dext(6,1.5,3.33).
</li>
<li>
dint(s) is the internal transition which is executed as soon as the system has elapsed the time indicated by the time-advance function.
<br/>
Example: If the system is in state 3 at a given time instant, the new state is computed by s<sub>new</sub>=dint(3).
</li>
<li>
ta(s) is the so called time-advance function which indicates how much time is left until the system undergoes the next internal transition. Note that the ta function is always dependent on the current state.
<br/>
If for example at time t=2 the system is in state 4, and the value of ta(s=4) is 3, the system will change its state autonomously at time t=5. If on the other hand, an event arrives in the meantime (let us say at time t=4.5) which puts the system into state 9, the new time when the system will change by itself is computed by t<sub>new</sub>=4.5+ta(s=9).
<br/>
Note that the time-advance function manipulates the simulation time of a model \"by hand\". There is no global clock anymore that gives equidistant ticks. When the system's time-advance function adopts a certain value, let us say three, it means that the system will be idle for the next three units of time (provided the absence of external inputs), so it does not make any sense to simulate this period of inactivity, and the system clock is allowed to directly jump three time units forward.
<br/>
The time-advance function is often represented by the variable sigma which holds the value for the amount of time that the system still has to remain in the current state (in the absence of external events). If sigma is present, the time-advance function merely returns sigma.
</li>
<li>
The lambda-function is the output function. It is only active before internal transitions. Thus, external transitions do not produce any output.
</li>
</ul>
<br/>
<br/>
<center><img src=\"../Images/DEVSTraj.png\" width=\"400\"></center>
<br/>
The above figure illustrates the mechanism of a DEVS model: the system receives inputs (see the uppermost graph) at certain time instants, changes its states according to the internal and external transitions, and gives outputs (see the lowermost graph). The graph in the middle shows the state trajectory of the system. Apparently, the system starts in state s<sub>1</sub> and changes to state s<sub>2</sub> after the time advance ta(s<sub>1</sub>) has been elapsed. Right before executing the internal transition, it generates the output y<sub>1</sub>. When it receives the input x<sub>1</sub>, it again changes its state, this time though undergoing the external transition. Note that no output is produced. When the time advance of state s<sub>3</sub> has been elapsed, it produces an output (y<sub>2</sub>), executes the internal transition again and thereby changes to state s<sub>4</sub>.
<br/>
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>Coupled Models</b></font>
<br/>
<br/>
DEVS models can describe arbitrarily complex systems. The only drawback is that the more complex the system is, the more difficult it is to set up the correct functions (dint, dext, time-advance and lambda-function) that describe the system. Fortunately, most complex systems can be broken down into simpler submodels that are easier to handle. It is therefore convenient not to have just one model that tries to simulate the whole system, but an interconnection of a number of smaller models that, together, represent the system. Even though this approach seems to be very intuitive, it is only possible because DEVS models are closed under coupling [Cellier05], which means that a coupled model can can be described by the same functions  as an atomic model (internal, external, time-advance and lambda function). Due to this fact, coupled models can be seen as atomic models, too, which allows for hierarchical modelling.
<br/>
The following figure illustrates these ideas: the model N consists of two coupled atomic models M<sub>a</sub> and M<sub>b</sub>. N can be seen as an atomic model itself and it is therefore possible to connect it to further models (coupled or atomic ones).
<br/>
<center><img src=\"../Images/CoupledDEVS.png\" width=\"300\"></center>
<br/>
In such a network where submodels interact with each other through ports, so that output events of one submodel are transformed automatically into input events for other submodels, events do not only carry the output value but also a number indicating the port where the event is appearing. Hence, inputs and outputs take the following form:
<center> X=Y= [real numbers] <b>x</b> [non-negative integers] </center>
The figure above suggests this circumstance by numbering the input and output ports of the models.
<br/>
Besides \"normal\" connections between submodels (M<sub>a</sub> and M<sub>b</sub> in our case), there are also connections that lead to or come in from the outside: as already mentioned, model N can be seen as an atomic model with two input and two output ports. Events coming in through port number 0 are immediately forwarded to submodel M<sub>a</sub>, those from port number 1 to M<sub>b</sub>. This kind of connection is called external input connection. Analogous, the connections leading from the output ports of the submodels to the output ports of the surrounding model N are called external output connections.
<br/>
<br/>
The behaviour of model N is determined by the behaviour of its submodels M<sub>a</sub> and M<sub>b</sub>. The actual task of N is to wrap M<sub>a</sub> and M<sub>b</sub> in order to make them look like as if they were one single model.
The dynamics of N (or any multi-component/coupled model) can be defined by the following loop [Kofman03]:
<ol>
<li>
Evaluate the atomic model that is the next one to execute an internal transition. Let this model be called d* and let tn be the time when the transition has to take place.
<br/>
In case there are more than one candidates ready to execute their internal transitions, choose the one that is designed by the so called tie-breaking function (the tie-breaking function imposes an ordering onto the components of the model, such that in case of two components ready to execute their internal transition, the simulation knows which one to process first).
</li>
<li>
Advance the simulation time (of the coupled model) to t=tn and let d* execute the internal transition. Note that tn=t<sub>cur</sub>+ta(s<sub>cur</sub>).
</li>
<li>
Forward the output event produced by d* to all atomic models that are connected to d* and let them execute their external transitions.
<br/>
Go to step 1.
</li>
</ol>
While until now we have justified coupled models by the need of splitting up too complex models into smaller, simpler submodels, it has of course also the reverse effect of allowing the predefinition of a number of atomic models (a \"model pool\" of frequently used models such as switches, comparators, etc.), which then can be used to build more complex models.
</p>
<br/>
<br/>
</html>"));
    end DEVSformalism;

    package QSS "Quantised State Systems"
    annotation (Documentation(info="<html>
<font color=\"#008000\" size=5><b>Quantised State Systems</b></font>
<br/>
<br/>
This section explains a) why the <a href=\"Modelica://ModelicaDEVS.UsersGuide.DEVSformalism\">DEVS formalism</a> is suited to simulate a continuous system and b) how this is done in a correct way preserving the DEVS formalism's rule of legitimacy.
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>Discrete Simulation of a Continuous System</b></font>
<br/>
<br/>
For a system to be representable by a DEVS model, the only condition is to show an input/output behaviour that is describable by a sequence of events. In other words, the DEVS formalism is able to model any system with piecewise constant input/output trajectories, since piecewise constant trajectories can be described by events [Cellier05].
<br/>
Hence, if we want to simulate a continuous system by a DEVS model, we \"just\" have to transform the continuous system into a system with piecewise constant input/output trajectories.
<br/>
This was the basic idea of a quantisation based method developed in the late nineties by Zeigler et al. [Zeigler98] to approximate a continuous system by a discrete-event simulation: a quantisation function was used to transform the continuous state variables into quantised discrete valued variables (a quantisation function maps all real numbers into a discrete set of real values).
<br/>
Let us see now what it needs to quantise a continuous system. Consider the following system given in its state-space representation (remember that usually, continuous systems are described by a set of differential equations):
<br/>
<br/>
<center> dx/dt= f(x(t), u(t),t)</center>
<br/>
where x(t) is the state vector and u(t) is the input vector, i.e. a piecewise constant function.
<br/>
The corresponding quantised state system has the following form:
<br/>
<br/>
<center> dx/dt= f(q(t), u(t),t) </center>
<br/>
where q(t) is the (componentwise) quantised version of the original input vector x(t), whereas a very simple quantisation function could be
<br/>
<br/>
<center> q(t)= floor(x(t)) </center>
<br/>
The figure below shows the respective block diagrams for the systems defined above. Note that the representation by block diagrams will be useful as soon as we will want to map the system onto a (coupled) DEVS model.<br/>
<center><img src=\"../Images/BlockDiagrams.png\" width=\"400\"></center>
Unfortunately the subject is not as simple as it may seem: the transformation of a continuous system into a discrete one by applying an arbitrarily chosen quantisation function can yield an illegitimate system (definition [Cellier05]: <i>\"A DEVS model is said to be legitimate if it cannot perform an infinite number of transitions in a finite interval of time.\" </i> Illustrative examples of cycling (illegitimate) systems can be found in [Kofman01] and [Cellier05]). Hence, such an illegitimate system would perform an infinite number of transitions in a finite time interval. As a matter of fact, even Zeigler's quantisation based method featured this problem, as the original approach of using a piecewise constant quantisation function did not preclude illegitimate systems automatically [Kofman01]. Thus, the quantisation function has to be chosen very carefully, such that it prevents the system from switching states an infinite number of times in a finite time interval. This property can be achieved by adding hysteresis to the quantisation function (proven in [Kofman01]), which leads straightforward to the notion of Quantised State Systems that have been introduced by Kofman in 2001 in order to circumvent the issue of illegitimate system transformations.
<br/>
<br/>
The subsequent paragraphs shall give a brief introduction into the theory and use of Quantised State Systems as a (sufficient) means to approximate continuous systems by discrete events. Special attention is paid to the role of hysteresis in the quantisation function.
<br/>
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>Quantised State Systems (QSS)</b></font>
<br/>
<br/>
Quantised State Systems are defined as follows [Kofman01]: <i>\"QSS are continuous time systems where the input trajectories are piecewise constant functions and the state variable trajectories - being themselves piecewise linear functions - are converted into piecewise constant functions via a quantisation function equipped with hysteresis.\"</i>
<br/>
<br/>
The goal of Quantised State Systems is to provide a legitimate system that can be simulated by the DEVS formalism. These two properties are achieved by a) the fact that the input/output trajectories are piecewise constant functions, which allows the simulation by the DEVS formalism, and b) the addition of hysteresis to the quantisation function by which the continuous system is transformed into the discrete representation.
<br/>
<br/>
A hysteretic quantisation function is defined as follows [Cellier05]: Let Q={Q<sub>0</sub>,Q<sub>1</sub>,...,Q<sub>r</sub>} be a set of real numbers where Q<sub>k-1</sub>< Q<sub>k</sub> with 1<= k<= r. Let Omega be the set of piecewise continuous trajectories and let x element of Omega be a continuous trajectory. The mapping b: Omega -> Omega is a hysteretic quantisation function if the trajectory q=b(x) satisfies:
<br/>
<table>
<tr>
<td>q(t) =</td><td>Q<sub>m</sub></td><td>if t=t<sub>0</sub></td>
</tr>
<tr>
<td></td><td>Q<sub>k+1</sub></td><td>if x(t)=Q<sub>k+1</sub> and q(t<sup>-</sup>)= Q<sub>k</sub> and k &lt; r </td>
</tr>
<tr>
<td></td><td>Q<sub>k-1</sub></td><td>if x(t)=Q<sub>k</sub> -&epsilon; and q(t<sup>-</sup>)= Q<sub>k</sub> and k > 0 </td>
</tr>
<tr>
<td></td><td>q(t<sup>-</sup>)</td><td>otherwise </td>
</tr>
</table>
and
<br/>
<br/>
<table>
<tr>
<td>m =</td><td>0</td><td>if x(t<sub>0</sub>) &lt; Q<sub>0</sub></td>
</tr>
<tr>
<td></td><td>r</td><td>if x(t<sub>0</sub>) >= Q<sub>r</sub> </td>
</tr>
<tr>
<td></td><td>j</td><td>if Q<sub>j</sub> &lt;= x(t<sub>0</sub>) &lt; Q<sub>j+1</sub></td>
</tr>
</table>
The discrete values Q<sub>i</sub> and the distance Q<sub>k+1</sub> - Q<sub>k</sub> (usually constant) are called the quantisation levels and the quantum respectively. The boundary values Q<sub>0</sub> and Q<sub>r</sub> are the upper and the lower saturation values, and &epsilon; is the width of the hysteresis window. The following figure shows a quantisation function with uniform quantisation intervals.
<center><img src=\"../Images/QuantWithH.png\" width=\"300\"></center>
The figure below reveals the difference between a quantisation step without and with hysteresis: the left part represents a quantisation function without hysteresis that may change the value of q(t) due to an infinitesimal variation of the state variable x(t) (&Delta;x=0), which entails of course a potential change of q(t) within the same time step (&Delta;t=0). The right part embodies a hysteresis window of width &epsilon; and thus the change of q(t) is delayed, i.e. only performed when x(t) has changed to a sufficient extent (defined by &epsilon;: &Delta;x=&epsilon;) which introduces a time delay depending on how long it takes x(t) to change for the given extent (&Delta;t=&epsilon;).
<center><img src=\"../Images/QuantWithoutH.png\" width=\"200\"></center>
<br/>
A formal prove why adding hysteresis to a quantisation function guarantees a legitimate system transformation is given in [Kofman01].
<br/>
<br/>
The Quantised State System described above is a first-order approximation of the real system trajectory. Kofman however has also introduced second- and third-order approximations that - without the application of smaller \"step\" sizes (i.e. a smaller quantum value) - may reduce the error made by the approximation. These systems are referred to as QSS2 and QSS3. The higher-order Quantised State Systems are based on the Taylor series up to first- or second-order (for QSS2 and QSS3, respectively).
<br/>
Since the possibility of having different types of QSS has only been mentioned in view of the chapter about <a href=\"Modelica://ModelicaDEVS.UsersGuide.ModelicaDEVS\"> ModelicaDEVS</a>, they are not discussed any further here. However, a detailed description of the QSS2 and the QSS3 can be found in [Kofman02] and [Kofman05] respectively.
<br/>
<br/>
</html>"));
    end QSS;

    package PowerDEVS "PowerDEVS"
    annotation (Documentation(info="<html>
<font color=\"#008000\" size=5><b>PowerDEVS - A C++ Implementation of the DEVS Formalism</b></font>
<br/>
<br/>
As mentioned in the <a href=\"Modelica://ModelicaDEVS.UsersGuide.Introduction\">
introductory</a> section, PowerDEVS served as kind of a template for <a href=\"Modelica://ModelicaDEVS.UsersGuide.ModelicaDEVS\"> ModelicaDEVS</a>: although the simulator of ModelicaDEVS is fundamentally different the components of ModelicaDEVS have been built according to the blocks in the PowerDEVS library.
<br/>
<br/>
A short but accurate description of the software's main achievements is given in the abstract of \"PowerDEVS: A DEVS-Based Environment for Hybrid System Modeling and Simulation\" [Kofman03]: <i>\"PowerDEVS allows defining atomic DEVS models in C++ language which can be then graphically coupled in hierarchical block diagrams to create more complex systems. Both, atomic an coupled models, can be organized in libraries which facilitate the reusability features. The environment automatically translates the graphically coupled models into a C++ code which executes the simulation.\"</i>
<br/>
<br/>
This section gives a brief introduction into the simulation mechanism of PowerDEVS. For more details you may also download the PowerDEVS code/software from <a href=\"http://www.fceia.unr.edu.ar/lsd/powerdevs/\"> http://www.fceia.unr.edu.ar/lsd/powerdevs/</a> .
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>The Modelling Environment</b></font>
<br/>
<br/>
Like many other simulation software systems, PowerDEVS provides a graphical editor where models can be built graphically. Note that it would be possible to declare them directly in C++ code. This however would be rather cumbersome and error-prone, and using the automatic transformation of PowerDEVS is recommended.<br/>
Since the handling of the modelling environment is fairly intuitive and anyway not critical to the understanding of the simulator, it is not explained in greater detail here.
<br/>
<br/>
An interesting subject to dwell some more on, however, is the way the graphical representation of a model is transformed into C++ code, in order to be utilisable by the simulator framework.
<br/>
<br/>
<center><img src=\"../Images/Example11.jpg\" width=\"300\"></center>
<br/>
Assume the sample model in the obove figure. When the \"run\" button in the modelling environment is pressed, PowerDEVS creates a file called \"model.h\" that holds a C++ description of the model. All information that will be needed for the simulation later on is stored in this file.
<br/>
The following code corresponds to the model in the figure above, but for simplicity, the output components \"ToDisk1\", \"ToDisk2\", \"ToDisk3\" and \"QuickScope1\" have been removed:
<pre>
 1 #include \"textonly/simulator.h\"
 2 #include \"textonly/root_simulator.h\"
 3 #include \"textonly/connection.h\"
 4 #include \"textonly/coupling.h\"
 5 #include \"textonly/root_coupling.h\"
 6 #include <Source\\step13.h>          //include the Step block
 7 #include <Continuous\\nlfunction.h>  //include the NLfunction block
 8 #include <Continuous\\integrador.h>  //include the integrator
 9
10 class model:public root_simulator {
11
12  root_coupling* Coupling0001;
13  simulator* child00010001;   //step
14  simulator* child00010002;   //NLfunction
15  simulator* child00010003;   //integrator
16  connection* EIC0001[1];     //external input connections
17  connection* EOC0001[1];     //external output connections
18  connection* conn00010001;
19  connection* conn00010002;
21  connection* conn00010003;
21  connection* IC0001[3];      //array containing all connections between blocks
22  simulator* D0001[3];        //array containing all blocks
23
24  public:
25
26  model(bool* r):root_simulator(r){}    //the model allocated in main() is a root_simulator
27
28  void configure(){    //this function will be called from the main() function in model.cpp
29
30    Coupling0001=new root_coupling();   //the \"global\" coupling
31
32    child00010001= new step13();        //allocate a new Step block
33    D0001[0]=child00010001;             //insert the Step block into block array
34    child00010002= new nlfunction();
35    D0001[1]=child00010002;
36    child00010003= new integrador();
37    D0001[2]=child00010003;
38
39    conn00010001= new connection();       //allocate a new connection
40    conn00010001->setup(0 , 0 , 1 , 0);   //connection from step to NLfunction, port 0
41    IC0001[0]=conn00010001;               //insert into array of connections
42    conn00010002= new connection();
43    conn00010002->setup(1 , 0 , 2 , 0);   //connection from NLfunction to integrator
44    IC0001[1]=conn00010002;
45    conn00010003= new connection();
46    conn00010003->setup(2 , 0 , 1 , 1);   //connection from Integrator to NLfunction, port 1
47    IC0001[2]=conn00010003;
48
49    //setup coupling, passing the block and connection arrays (and their sizes)
50    Coupling0001->setup(&D0001[0], 3, &IC0001[0], 3);
51
52    MainCoupling = Coupling0001;       //set MainCoupling
53    Coupling0001->rsim=this;
54    ti = 0;                            //simulation start time
55    tf = 10;                           //simulation final time
56
57    //initialize blocks with the appropriate values for their parameters
58    child00010001->init(0, 0.0,1.76,10.0);
59    child00010002->init(0, \"-u1+u0\", 2.0);
60    child00010003->init(0, \"QSS\",1.0,10.0,\"integrator.csv\");
61    Coupling0001->init(0);
62  }
63 };
</pre>
As a last point worth mentioning, there is the incorporation of the tie-breaking function by the so called Priority Window (Accessible through the menu Edit, Priorities), which allows the modeller to specify a particular priority order among the components:
<center><img src=\"../Images/example11priority.jpg\" width=\"150\"></center>
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>The Simulator</b></font>
<br/>
<br/>
The PowerDEVS simulator framework enables the user to simulate a system that is available in the C++ format shown before. Normally, this is the result of modelling it graphically in the PowerDEVS graphical editor followed by an automatic transformation into the aforementioned C++ data structures.
<br/>
The subsequent sections will give insight into the simulator architecture both on a more theoretical level as well as on the level of its actual implementation in C++.
<br/>
<br/>
<b>Simulator Theory</b>
<br/>
The PowerDEVS simulator is based on the abstract simulator concept developed by Zeigler [Zeigler84]. To make allowance for the possibility of coupled/hierarchical DEVS systems, PowerDEVS models embody the structure shown in the following figure, whereas simulators represent atomic models and coordinators represent coupled models.
<br/>
<center><img src=\"../Images/Hierarchy.png\" width=\"300\"></center>
<br/>
As soon as there are two or more components constituting the model, it is necessary to make them able to communicate with each other (send and receive output/input signals). The most intuitive approach would probably be the following: each block keeps a list of the blocks that are connected to its output port, and whenever the block produces an output event, it sends a message to the connected blocks in order to make them undergo their external transition. It is however not the approach chosen in Zeigler's abstract simulator/PowerDEVS. PowerDEVS rather leaves the control of the interaction within a set of blocks to the coordinator that is declared to be responsible for these particular blocks. If for example block A has to generate an output event that has to be sent to block B, it is the coordinator that a) sends a message (called \"lambdamessage\" in PowerDEVS) to block A in order to trigger the &lambda;-function and b) passes the generated output event to the block B. Of course, both approaches (the intuitive one as well as the one applied in PowerDEVS) lead to the same result. Thus, a modeller does not have to think of the complicated coordinator-simulator concept but may consider the blocks to act autonomously (\"block A decides to produce an event and sends it to block B\").
<br/>
<br/>
Let us study the PowerDEVS solution to the component interaction issue in more detail. The figure above depicts the possible hierarchical structure and the corresponding simulation scheme of a DEVS model. The messages between coordinators and simulators up and down the tree consist of the following two types:
<ul>
<li>
Down-messages: coordinators send messages to their children, triggering the execution of the different functions (&delta;<sub>int</sub>, &delta;<sub>ext</sub>, &lambda;-function).
</li>
<li>
Up-messages: when the &lambda;-function of a simulator has been called by the coordinator, it returns the output value to its parent coordinator (the caller).
<br/>
Note that coordinators look like simple simulators to their parent coordinators. Hence, if a coordinator (e.g. coupled<sub>1</sub> in the figure above) receives an output value that has to be propagated outside the corresponding coupled model, it sends this value to its own parent coordinator (coupled<sub>2</sub>).
</li>
</ul>
We can see that simulators do not interact directly with other simulators on the same layer, but only pass their outputs to the parent coordinator which then is responsible for the propagation of the signal to the appropriate simulators (i.e. those which are connected to the \"firing\" simulator). The communication between simulators can thus be said to be monitored by the associated coordinator.
<br/>
<br/>
Since both coordinators and simulators have to be valid DEVS models, they have to feature the typical DEVS functions: &delta;<sub>int</sub>, &delta;<sub>ext</sub>, the time-advance and the &lambda;-function. In simulators, these functions simply define the inherent behaviour of the block in question. In the case of a coordinator however, they have a slightly different meaning/effect:
<ul>
<li>
External transition - the purpose of the external transition of a coordinator is to invoke external transitions in the appropriate simulators:
When a coordinator receives a signal, it simply forwards it to those among its children that have their input ports connected to the input ports of the coordinator (see the following figure), and thereby triggers these simulators to execute their external function.
<center><img src=\"../Images/EIC.png\" width=\"200\"></center>
</li>
<li>
Internal transition -- the purpose of the internal transition of a coordinator is to invoke internal transitions in the appropriate simulators: All simulators and coordinators have a local variable tn which indicates the time when their next internal transition will take place. In a simulator, this variable corresponds simply to the sum of the current time and the value of the time-advance function (or &sigma;). The value of tn in a coordinator on the other hand is the minimum of the tn values of its associated components, thus indicating the next time instant when a simulator undergoes its internal transition. Besides the time <b>when</b> the transition is executed, the coordinator also stores the information <b>where</b> (at which simulator) it takes place. For this reason, it features a second variable dast (corresponding to d*) where it stores the ID of the respective simulator. Having this information at its disposal, the internal transition of a coordinator just consists of sending an internal-transition-message (called \"dintmessage\" in PowerDEVS) to the simulator stored in dast, which then will execute its own internal transition.
<br/>
Note that in order to always have an updated pair dast/tn available, a coordinator scans its children every time it receives the instruction to execute an internal or external transition, and stores the block with the smallest time-advance into dast and the corresponding time-advance value into tn.
</li>
</ul>
Let us investigate now, how a signal moves through the tree of coordinators and simulators. Consider a hierarchy like the one in the subsequent figure, which has the same topology as the example above, but with directed connections).
<br/>
<center><img src=\"../Images/MovingSignal.png\" width=\"200\"></center>
Suppose that coupled<sub>2</sub> has just noticed that atomic<sub>3</sub> is ready to undergo its internal transition (apparently, it has the smallest tn value). For this reason, coupled<sub>2</sub> sends a message to atomic<sub>3</sub>, which then executes its internal transition. Instead of sending the output directly to coupled<sub>1</sub> (which looks like another simulator to atomic<sub>3</sub>), it returns it to its father coordinator, coupled<sub>2</sub>. coupled<sub>2</sub> checks now what components are attached to the output port of atomic<sub>3</sub> and finds coupled<sub>1</sub>, to which it propagates the output of atomic<sub>3</sub>. coupled<sub>1</sub> has now just received an external event that makes it execute an external transition. Since coupled<sub>1</sub> is a coordinator, this transition just consists of forwarding the signal to the simulators connected to its input ports. In our example, this is only atomic<sub>1</sub>, which now executes its external transition and thereby sets its local variable tn to a new value. As mentioned before, when a coordinator (coupled<sub>1</sub> in this case) forwards an external event, it scans the tn values of its children in order to update dast and its own tn value. Note that this update already involves the new tn value of atomic<sub>1</sub>. The next step depends now on whether atomic<sub>1</sub> or atomic<sub>2</sub> has the smaller tn value and therefore is the imminent component to execute its internal transition.
<br/>
<br/>
So much for the theoretical background of the PowerDEVS model simulator. When comparing this simulation scheme to the way <a href=\"Modelica://ModelicaDEVS.UsersGuide.ModelicaDEVS\"> ModelicaDEVS</a> works, it can be easily seen that there are several fundamental differences between the two simulator concepts.
<br/>
<br/>
</html>"));
    end PowerDEVS;

    package ModelicaDEVS "ModelicaDEVS"
    annotation (Documentation(info="<html>
<font color=\"#008000\" size=5><b>ModelicaDEVS - A Modelica Implementation of the DEVS Formalism</b></font>
<br/>
<br/>
ModelicaDEVS is a Dymola/Modelica library that provides the tools for discrete-event simulation incorporating the DEVS formalism, where \"the tools\" are simply a number of <a href=\"Modelica://ModelicaDEVS.UsersGuide.ModelicaDEVS.LibraryOverview\">predefined DEVS blocks</a> from which large models can be built.
<br/>
<br/>
As pointed out in the <a href=\"Modelica://ModelicaDEVS.UsersGuide.Introduction\">Introduction</a>, the scope of ModelicaDEVS is to provide a similar functionality as <a href=\"Modelica://ModelicaDEVS.UsersGuide.PowerDEVS\"> PowerDEVS</a> does. However, because of the different working paradigms of Modelica and C++, the re-implementation of PowerDEVS in Dymola is not a mere translation from C++ to Modelica. Although Dymola is, due to some of its features, very well suited for an implementation of the <a href=\"Modelica://ModelicaDEVS.UsersGuide.DEVSformalism\">DEVS Formalism</a> in Modelica, not all of its properties are advantageous. Some cause difficulties when trying to re-implement a Modelica version of PowerDEVS.
<br/>
The most important/interesting implementation issues regarding this subject - preceded by a brief description of the Dymola environment - shall be presented in the <a href=\"Modelica://ModelicaDEVS.UsersGuide.ModelicaDEVS.Theory\">\"ModelicaDEVS Theory\"</a> chapter.
<br/>
<br/>
</html>"));
      package Theory "Theory"
        annotation (Documentation(info="<html>
<font color=\"#008000\" size=5><b>Concepts of the ModelicaDEVS Library </b></font>
<br/>
<br/>
The subsequent sections provide a more \"theoretical\" background about ModelicaDEVS, discussing the problems that were encountered while implementing the <a href=\"Modelica://ModelicaDEVS.UsersGuide.DEVSformalism\"> DEVS Formalism</a> in Modelica, due to the pecularities of the the Dymola/Modelica programming environment.
<br/>
Note that the section about atomic models may also serve as a HOWTO for the translation of further DEVS models from C++ code (e.g. in the case of future developments within <a href=\"Modelica://ModelicaDEVS.UsersGuide.PowerDEVS\"> PowerDEVS</a>) into Modelica.
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>Dymola Programming/Simulation Environment</b></font>
<br/>
<br/>
This section presents some properties of Dymola/Modelica that are necessary for a thorough understanding of the subsequent sections in this chapter.
<br/>
<br/>
<b>Simultaneous Equations</b>
<br/>
While C++ is an imperative programming language and lives on the principle of functions calling other functions, Modelica models are described mathematically by equations, and the simulation makes use of the simultaneous evaluation of these model equations. This means that in every simulation step, Dymola collects <b>all</b> equations of a model, even if they are spread over several blocks, and then tries to evaluate them. After it has found a value for each variable such that all equations are fulfilled, a new simulation step is started.
<br/>
A direct consequence of this approach is the parallel update (in terms of simulation time) of the state variables. This can be exploited for the implementation of DEVS in Modelica, but at the same time causes some problems that do not have to be dealt with when using a programming language like C++.
<br/>
<br/>
<b>Simulation Time</b>
<br/>
The simulation environment of Dymola comes with a global clock that is accessible through the variable time. Note that it is not possible to set the clock by assigning a certain value to time. The purpose of the variable time is only to give the programmer the opportunity to query the current simulation time.
<br/>
<br/>
<b>State and Time Events</b>
<br/>
Another particularity of Dymola is the time or state events that are triggered by equations containing inequalities.
<br/>
<br/>
The scope of state events is to inhibit discontinuities during integration. For an example, consider the following Modelica model (see also [Dymola]) and the corresponding graph:
<table>
<tr>
<td>
<pre>
model EventTest
  input Real u;
  output Real y;<
equation<br/>
  y = if u>0 then 1 else -1;
end EventTest;
<pre>
</td>
<td><img src=\"../Images/DymolaEvents.png\" width=\"100\"> </td>
</tr>
</table>
At the point u=0, the equation for y is discontinuous. Such discontinuities caused by a relation like u>0 raise a problem because the branch of the if-statement can be switched at a certain point in time, and all of a sudden y can take a completely new value, \"artificially\" assigned, that has nothing to do with the previous trajectory of y.
<br/>
The solution of Dymola to this problem is to stop the integration at point $u=0$, select the appropriate branch of the if-statement and restart the simulation with new initial conditions. Note that there are situations when no state events have to or even must be triggered. This can be achieved by using the noEvent() operator. For more details see [Dymola] or [Modelica].
<br/>
<br/>
Inequalities that only depend on the variable time as the only continuous unknown variable may also trigger time events instead of state events. The following table illustrates which relations still cause state events - even if time is their only continuous variable - and which entail only time events:
<center>
<table>
<tr><td><b>State Events</b></td><td><b>Time Events</b></td></tr>
<tr><td>time &lt;= [discrete expression]</td><td>time >= [discrete expression]</td></tr>
<tr><td>time > [discrete expression]</td><td>time &lt; [discrete expression]</td></tr>
</table>
</center>
Whereby the discrete expression may itself be a function of constants, prameters, and discrete variables, but not continuous variables.
<br/>
<br/>
The main difference between time and state events is that Dymola does not have to iterate on time events but \"jumps\" directly to the point in time when the time event will arise. Thus, they may save computation time, and it is recommended to use time events instead of state events wherever it is possible.
<br/>
ModelicaDEVS has been implemented using time events as much as possible, limiting the use of state events to those few situations only, where they could not be avoided. This approach is also described in [Fritzson04].
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>Atomic Models</b></font>
<br/>
<br/>
The mapping of an atomic model from PowerDEVS to Modelica does not yet cause many difficulties but is rather a translation of the C++ code into Modelica - which however is not as straightforward as would be a translation to Java or Pascal, as we shall see.
<br/>
Of course, the design of an atomic model has to provide the features requested by the simulation of a coupled model and therefore already involves the solutions to the issues that will be discussed in the subsequent sections. It is hence possible that the general block structure developed in this section is not yet fully understandable. However, the basic concepts should be clear and allow for a better understanding of the subsequent sections.
<br/>
<br/>
<b>Events/Ports</b>
<br/>
An event in PowerDEVS consists of four values: the event creation time and the coefficients to the first three terms (constant, linear and quadratic) of the function's Taylor series expansion. In other words, an event is described by the current function value, the first derivative of the function at the current time instant and its second derivative devided by two.
<br/>
The higher-order approximated output of <a href=\"Modelica://ModelicaDEVS.UsersGuide.QSS\">QSS2</a> and <a href=\"Modelica://ModelicaDEVS.UsersGuide.QSS\">QSS3</a> models is then equal to the first-order or second-order Taylor series expansion: the output is given by
<center>y[0]=y[0]+y[1]*(t-t<sub>last</sub>) + y[2]* (t-t<sub>last</sub>)^2</center>
which, with the entries of the y-vector holding the coefficients to the first three terms of the Taylor series expansion, corresponds to the Taylor series up to second-order for QSS3, or first-order for QSS2 where y[2] is always 0.
<br/>
Note that the coefficients to the linear and the quadratic terms of the Taylor series are only used for QSS2 and QSS3.
<br/>
Since these values sufficiently describe an event, ModelicaDEVS simply adapts this structure to a large extent. The only difference is the replacement of the event creation time by a boolean variable that indicates whether a certain block is currently sending an event. Hence, whereas PowerDEVS port are represented by single vectors, ModelicaDEVS ports consist of a vector of size three (for the three input/output values) and the aforementioned boolean variable. The code snippet below shows the declaration of a ModelicaDEVS input port. Output ports are declared analogously:
<br/>
<br/>
<pre>
connector DiscreteInPort \"Discrete Connector\"
  input Real signal[3];
  input Boolean event;
end DiscreteInPort;
</pre>
<br/>
Within the equation section of the Modelica model the parts of the input/output ports are referred to as uVal[1], uVal[2], uVal[3] and uEvent for input ports, and yVal[1], yVal[2], yVal[3] and yEvent for output ports. The name conversions from a vector named signal to a vector named uVal and a boolean variable event to a variable uEvent takes place in the block <a href=\"Modelica://ModelicaDEVS.Templates\"> templates</a> from which all ModelicaDEVS models are derived.
<br/>
<br/>
Remark: for simplicity reasons, we shall pretend that ModelicaDEVS input/output ports are represented by single vectors of size four, whereby the fourth entry is not of type real but of type boolean, instead of a vector of size three plus a boolean variable. In reality, it is of course not possible to have mixed arrays, but this assumption facilitates the writing and understanding of sections dealing with event-passing issues: it is no longer necessary to make a distinction between the vector part of the port and the boolean variable, but we can simply think of the boolean variable to be the fourth entry in the vectors that represent the input/output ports of ModelicaDEVS models.
<br/>
<br/>
<b>Transitions</b>
<br/>
A DEVS model consists of the following subroutines (cf. the section about the <a href=\"Modelica://ModelicaDEVS.UsersGuide.DEVSformalism\"> DEVS formalism </a>): internal transition, external transition, time-advance, and lambda function. PowerDEVS components additionally contain an initialisation function. For ModelicaDEVS, this means that basically all these parts have to be explicitly or implicitly present (including the initialisation function).
<br/>
As already mentioned, Modelica and C++ operate on different paradigms, (simultaneous equations vs. sequential processing) which impedes a direct translation without major modifications. With the help of some gimmicks however, respecting certain rules and restrictions, the C++ code can be transformed into Modelica rather easily. Note though that the code obtained by such a \"mechanical\" translation is only more or less a correct copy of the PowerDEVS model and has to be examined for possible intrinsic particularities that may require further block specific programming.
<br/>
The following text discusses the way that has been chosen to create Modelica models with equal functionality to the PowerDEVS blocks.
<br/>
<br/>
The time-advance function is represented by a variable sigma. There is hence no reason for an explicit time-advance function anymore (PowerDEVS still implements it because it is needed for the hierarchic simulator framework). Note that even in the theoretical definition of a DEVS model it is a popular trick to represent the time-advance function by a variable called sigma.
<br/>
<br/>
A variable lastTime holds the time of the last execution of a transition (internal or external). This variable is used for the computation of the variable e (&epsilon; in the original DEVS definition)
<center> <pre>e=time-pre(lastTime);</pre></center>
where e is the time the system has already spent in the current state.
<br/>
<br/>
Two boolean variables, dint and dext, are used to determine if there is currently any internal or external event to be processed.
<br/>
An internal transition depends only on sigma (the time-advance function) and e (&epsilon;). Hence, the value of dint can be calculated as:
<center> <pre>dint= time >= pre(lastTime)+pre(sigma);</pre></center>
The external transition of a block B attached to the output port of a block A is executed at the very moment when A generates an output event. This is where the fourth entry in the port vector comes in. The variable dext of a block B is defined as follows:
<center> <pre>dext = uEvent;</pre></center>
where uEvent is the fourth entry of the input vector of B (A.yEvent = B.uEvent).
<br/>
<br/>
The lambda function and the internal/external transitions are represented by when-statements. Most blocks feature two when-statements:
<ul>
<li>
A when-statement that is active when dint becomes true. It can be seen as the analogon to the lambda function, which always proceeds an internal transition.
</li>
<li>
A when-statement that is active when either dint or dext become true. It holds the code for both the external and internal transitions.
</li>
</ul>
What is the reason for this perhaps not very intuitive structure? Why not just have two when-statements, one representing the internal transition and the lambda function, the other one representing the external transition? The reason for packing the internal and external transitions into a single when-statement is due to a rule of the Modelica language specification that states that equations in different when-statements may be evaluated simultaneously (Modelica cannot/does not check for mutually exclusive when-statements). Hence, if there are two when-statements each containing an expression for a variable X, X is considered overdetermined. This circumstance would cause a syntactical problem with variables that have to be updated both during the internal and the external transition and thus would have to appear in both when-statements. For this reason, we need to have a when-statement that is active if either dint or dext becomes true. An additional discrimination is done \\textbf{within} the when-statement, determining whether it was an internal (dint is true) or an external transition (dext is true) that made the when-statement become active, and as the case may be, updating the variables with the appropriate value (note that most variables take different values during internal transitions compared to external ones).
<br/>
A typical \"dint-dext\" when-statement looks like one of the following (assume three variables X, Y, Za and Zb where X is updated during the internal transition, Y during the external transition, Za during both transitions but to different values and Zb also during both transitions but to the same value):
<pre>
when {dint, dext} then        when {dint, dext} then
  if dint then                  X = if dint then 4 else pre(X);
    X = 4;                      Y = if dint then pre(Y) else 9;
    Y = pre(Y);                 Za= if dint then 6 else 7;
    Za= 6;                      Zb= 2;
  else                        end when;
    X = pre(X);
    Y = 9;
    Za= 7;
  end if;
  Zb= 2;
end when;
</pre>
Having now a place where equations for variables that are modified during the internal transition can go, what is the purpose of the second when-statement, which is also - though exclusively - active if dint becomes true? Its main justification is to separate the internal/external transitions from the output part. Furthermore, the output variables are only updated before an internal transition, thus, they do not necessarily need to appear within a dint-dext when-statement.
<br/>
The typical \"lambda-function\" part (containing a when-statement and a separated instruction for the yEvent variable) looks as follows:
<pre>
when dint then
  yVal[1]= ...;
  yVal[2]= ...;
  yVal[3]= ...;
end when;
  yEvent = edge(dint);
</pre>
Note that the right hand side of the equations in the lambda function normally depends on pre() values of the used variables. This is due to the fact that the lambda function has to be executed <b>prior to</b> the internal transition. In ModelicaDEVS however, the two corresponding parts in the model are activated simultaneously (namely, when dint becomes true), so the temporal distinction between the lambda function and the internal transition has to be done via the pre() operator of Modelica.
<br/>
The variable yEvent has to be true in the exact instant when an internal transition is executed and false otherwise. This behaviour is obtained by using the edge() operator of Modelica, where the edge() operator returns true at the time instant when the value of its argument switches from false to true and false at any other time instant.
<br/>
<br/>
<b>Miscellaneous</b>
<br/>
For variables that are modified more than once during one simulation step, or that are updated by means of a complicated combination of if-then-else-statements, it is recommended to declare a function that contains an almost exact copy of the C++ code segment in question (an example where this method was applied is the ModelicaDEVS Integrator block).
<br/>
<br/>
A very important advice in this context is to always carefully check for occurrences of the sqrt() function and make sure that it is only called with a positive argument. In case the argument becomes negative, assign a value of infinity to the variables the values of which would have been computed using the sqrt() function. Otherwise, the Modelica models show an erroneous behaviour, which is often fairly illogical and thus hard to find. It is therefore more than just advisable to pay attention to this detail since from the beginning.
<br/>
Note that returning infinity if sqrt() is called with a negative argument is what a C++ compiler does. Therefore, the current version of PowerDEVS which does not yet check for negative arguments to sqrt(), works adequately. This is however a poor programming style, and the sqrt() issue is subject to be corrected in future versions of PowerDEVS.
<br/>
<br/>
<b>Basic Model Structure</b>
<br/>
The average block of the ModelicaDEVS library exhibits the following basic structure:
<pre>
block SampleBlock
  extends ModelicaDEVS.Interfaces. ... ;
  parameter Real ... ;
protected
  discrete Real lastTime(start=0);
  discrete Real sigma(start=...);
  Real e;     //epsilon - how long has the system been in this state yet?
  Boolean dext;
  Boolean dint;
  [...other variable declarations...]

equation
  dext = uEvent;
  dint = time>=pre(lastTime)+pre(sigma);

  when {dint} then
    yVal[1]= ...;
    yVal[2]= ...;
    yVal[3]= ...;
  end when;
    yEvent = edge(dint);

  when {dext, dint} then
          e=time-pre(lastTime);
    if dint then
      [...internal transition behaviour...]
    else
      [...external transition behaviour...]
    end if;
    lastTime=time;
  end when;

end SampleBlock;
</pre>
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>Coupled Models</b></font>
<br/>
<br/>
<b>Time-advance Mechanism</b>
<br/>
In Dymola, there is already a clock present, and it is recommended to use it as the actual simulation clock, since the graphical output (e.g. the values of state variables) will be plotted against time (on the x-axis), and if the simulation is not synchronized with the Modelica simulation clock, the graphical output may not be very illustrative anymore.
<br/>
<br/>
<b>Direct Block Interaction</b>
<br/>
The solution that was found for ModelicaDEVS to enable the required block interaction for coupled models is to pass a boolean signal along with the compulsory event values. The boolean signal is used to inform a block B about the occurrence of an output event at block A (given that block B is connected to the output port of block A).
<br/>
<br/>
Let us consider a small example. Assume a two-block system consisting of block A and block B, where block B is connected to the output port of block A. Every block features a variable dext accompanied by an equation
<center><pre> dext = uEvent;</pre></center>
where uEvent is the boolean component of the input vector that represents events. Suppose now that block A produces an event at time $t=3$. As already pointed out, an event consists of three state-related values plus a boolean variable. At the precise instant when A generates an event, it updates its output vector with the appropriate values and sets yEvent to true:
<pre>
when dint then
  yVal[1]= ...; //new output value 1
  yVal[2]= ...; //new output value 2
  yVal[3]= ...; //new output value 3
end when;
  yEvent = edge(dint);
</pre>
Still at time t=3, block B notices that now uEvent has become true (note that B.uEvent = A.yEvent) and therefore dext has become true, too. Block B is then going to execute its external transition.
<br/>
<br/>
<b>Concurrent Events</b>
<br/>
Two events that are generated at one and the same time are called concurrent events. There are four types of concurrent events, differing from each other by the location where in the system they occur:
<ul>
<li>
Type 1: Concurrent events that occur at different blocks in the model and that do not influence each other. There is no need to treat this case in a special way since Dymola/Modelica always looks at the model as a whole (concept of simultaneous equations). Hence, it will update the variables of the critical blocks in parallel (in terms of simulation time) anyway.
<li>
</li>
Type 2: Concurrent events that occur at the same block with two input ports (such as the Add-Block). In this case, the block has to provide a solution itself, e.g. either favour the processing of one of the external events or involve both of them in the computation of the new variable values.
<li>
</li>
Type 3: Concurrent events that occur at a block with only one input port. Given the fact that there is only one input port, these events must be an external and an internal event, whereas the external event occurs at the same time when the block in question should execute its internal transition. Note that this scenario of an external and an internal event at the same block can also be seen as two internal transitions in two connected blocks (the internal transition of the first block will be recognised as an external event by the second block).
<br/>
This situation brings up the topic of priorities, which is strongly related to the differences between ModelicaDEVS and PowerDEVS, and which will be covered in a separate section.
<li>
</li>
Type 4: Concurrent events that occur at the same block, caused by a loop. They are actually a special case of type-3 events, which however could cause even more troubles. Fortunately, the problem of events that instantaneously return to the same block they originate from is solved by Dymola itself, as will be seen in the section about loops. Hence, a solution to the problem of type-3 events automatically solves the type-4 events issue.
</li>
</ul>
Apparently, concurrent events only require additional attention if they occur at the same block. If the given block has two input ports, it has to provide a solution how to treat the two signals by itself. If it has only one input port, it will have to choose between the external event or the internal transition to process first. As already mentioned, this is related to the priority issue of the DEVS formalism and the problem of loops - depending on how the concurrent events have been generated.
<br/>
<br/>
<b>Loops</b>
<br/>
Loops occur if a variable X is being used (either on the right hand side of an equation or in a when-statement) to update a variable Y that is used to update the variable X. Due to the fact that the view of Modelica is model-wide (it treats all equations that appear in the components of a model equally), such a loop may also be spread over several blocks: a variable X of block A is used to update another variable Y in a block B that is used again to update the variable X of the block A (this corresponds to the problem in the section about priorities).
<br/>
Such cycles are called algebraic loops. They may be broken by applying the pre() operator on certain variables of the loop: the pre() operator characterizes the left limit of a variable at a given time instant and therefore may break the loop by inserting an infinitesimally small time delay between two updates of a loop-variable (see [Dymola] for more details).
<br/>
<br/>
Once the components are programmed correctly in terms of breaking potential loops by inserting the pre() operator in appropriate places, there is a second type of cycles that may occur: components that set their local variable sigma to zero during the external transition have to execute an internal transition immediately after (actually contemporarily to) the current external transition. Dymola solves such loops automatically by iterating until a consistent restart condition is found (using the infinitesimally small time delay induced by the pre() operator for variables that have to be updated twice or more times within one simulation step).
<br/>
<br/>
<b>Priorities</b>
<br/>
In fact, there is only one single situation where the importance of priority settings between components comes in: two connected blocks, where both block A and block B have to execute an internal transition at the same time.
<center><img src=\"../Images/DintDext.png\" width=\"200\"></center>
Block A actually does not even feel the presence of the concurrent events, and just processes the internal transition. This however causes a priority problem in block B which was about to go through an internal transition itself and now receives an external event at the same time, since the internal transition of block A entails an output that appears as an external event at block B.
<br/>
<br/>
In our simple two-block-example there are only two possible priority orderings with the following consequences:
<ul>
<li>
If block A is prior to block B, block A will produce the output event before block B executes the internal transition. Hence, block B will first execute an external transition triggered by the external event it received from block A.
<li>
</li>
If block B is prior to block A, it will first go through the internal transition and receive the external event right afterwards, when A will be allowed to execute its internal transition.
</li>
</ul>
The problem of block priorities can be solved in two ways: by an explicit, absolute ordering of all components in a model, or by letting every block determine itself whether it processes the external or the internal event first, in case both of them occur at the same time. While PowerDEVS makes use of the former approach, ModelicaDEVS implements the latter: because of the block-to-block nature of the communication in coupled models, a global priority list of all components would be useless or at least associated with additional effort for checks on the priority relation between two active components. It is therefore much more convenient to take this decision locally by simply determining whether to execute the internal or the external transition first.
<br/>
<br/>
In ModelicaDEVS, there is only a hard coded version of the priority handling implemented: an internal transition is always prior to an external one.
<br/>
The reason for this choice - the fixed ordering as well as the priority order of internal before external - lies in the way events are passed from block to block and in the inability of Dymola/Modelica to solve algebraic loops. Assume the following abstract code snippet containing the basic variables and when-statements to enable a block to recognise internal and external events and to produce output events.
<pre>
equation
  dext = uEvent;
  dint = time>=pre(lastTime)+pre(sigma);

  when {dint} then
    yVal[1]=...;
    yVal[2]=...;
    yVal[3]=...;
  end when;
    yEvent=edge(dint);

  when {dext, dint} then
    if dint then
      sigma = ...;  //something...
    else
      sigma = ...;  //something else...
    end if;
    lastTime=time;
  end when;
</pre>
There are two important facts to take into consideration: a) the boolean variable dext depends on uEvent, which is actually the output (the yEvent variable) of another block, and b) the variable yEvent of any component depends on the variable dint. Note that the way shown above is not the only one to program a block, but in any case the statements a) and b) hold, which is the critical point to the fixed priority order problem.
<br/>
Consider now a model that - in case of a concurrent occurrence of two events - attempts to execute the external transition before the internal transition. Then, the first when-statement in the code above would have to be changed into
<center><pre> when (dint and not dext) then</pre></center>
and yEvent would have to be modified into
<center><pre> yEvent = edge(dint and not dext)</pre></center>
<br/>
Note that the above assignment is actually invalid since the edge() operator expects a single variable as an argument. It however exactly demonstrates the meaning of the required modification. In correct Modelica, an auxiliary variable would have to be created, taking the value of \"dint and not dext\", that then can be passed to the edge() operator.
<br/>
This however would entail the update of the output variable yEvent to be dependent not only on dint, but on dext, too. Assume now a toy-scenario of a loop of two blocks A and B that execute their external transaction prior to the internal transaction and therefore have been programmed as described above, with the modified when-statement.
<br/>
<br/>
<center><img src=\"../Images/yEventDextLoop.png\" width=\"600\"></center>
<br/>
Because of the cycle between the variables yEvent, uEvent and dext (the output yEvent of one block becomes the input uEvent of the other block), such a scenario results in an algebraic-loop-error message of Dymola.
<br/>
More generally, we can say that <b>the output of a block must not depend directly on the input</b>, because a number n of blocks that are connected in a cycle (the output of block n is connected to the input of block 1) could cause the following dependency loop : output 1 depends on input 1; input 2 depends on output 1; output 2 depends on input 2; input 3 depends on output 2; ... ; input n depends on output n-1; output n depends on input n; input 1 depends on output n.
<br/>
<br/>
The cause for this issue is Modelica's principle of simultaneous equations and thus the problem cannot be avoided. For this reason, yEvent has to remain independent of dext and has to be updated in a way such that it depends solely on dint. Hence an internal transition has to be treated prior to an external one, because if dint becomes true, also yEvent does so. This however indicates the generation of an output event, and every output event <b>has</b> to be followed by an internal transition. If the external transition were treated with priority to the internal transition, it could give rise to a situation where the external transition is executed and an output is generated, which would be an illegal behaviour according to the DEVS formalism.
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>Hierarchic Models</b></font>
<br/>
<br/>
Since Dymola/Modelica is already aimed at object-oriented modelling, which includes the reuse of autonomous mo"
                 + "dels as parts of larger models, the issue of hierarchic systems did not need any particular treatment.
<br/>
Furthermore, because of the equation-based simulation mechanism, Dymola/Modelica does not handle hierarchical models differently to flat models: while simulating a model, Dymola collects the equations of <b>all</b> components constituting the model and evaluates them simultaneously. A second-level submodel contributes just some additional equations to the global equation \"pool\", but does not cause any further inconveniences, like in PowerDEVS, where hierarchical models entail a larger amount of messages passed between the hierarchy levels.
<br/>
<br/>
<br/>
<font color=\"#008000\"><b>Time/State Events</b></font>
<br/>
<br/>
As explained before, Dymola can trigger two types of events:
<ul>
<li>
State events that may require iteration to find a consistent restart condition (remember that the integration is interrupted and then continued with new starting conditions).
<li>
</li>
Time events that make Dymola \"jump\" directly to the point in time when the time event will arise.
</li>
</ul>
The only expressions that are responsible for activating the when-statements in the models,
<center>
<pre> dext = uEvent;</pre>
and
<pre> dint = time>=pre(lastTime)+pre(sigma);</pre>
</center>
both trigger time events and hence avoid the more expensive (in terms of computation time) state events.
<br/>
<br/>
A previous version of ModelicaDEVS used an approach that triggered only state events. According to performance comparisons carried out between the two versions, it has been found that the time event approach is roughly four times faster than its state event counterpart.
<br/>
<br/>
</html>"));
      end Theory;

      package LibraryOverview "Library Overview"
        annotation (Documentation(info="<html>
<font color=\"#008000\" size=5><b>ModelicaDEVS Library Overview</b></font>
<br/>
<br/>
Given the fact that every component in ModelicaDEVS is described in its own information section, only an alphabetical listing of the available blocks and the examples is given.
<p>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td colspan=2><b>Source Blocks</b> </td>
</tr>
<tr>
<td>1.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Constant\">
  Constant</a>
</td>
</tr>
<tr>
<td>2.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Pulse\">
  Pulse</a>
</td>
</tr>
<tr>
<td>3.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.PWM\">
  PWM</a>
</td>
</tr>
<tr>
<td>4.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Ramp\">
  Ramp</a>
</td>
</tr>
<tr>
<td>5.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.SamplerLevel\">
  SamplerLevel</a>
</td>
</tr>
<tr>
<td>6.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.SamplerTime\">
  SamplerTime</a>
</td>
</tr>
<tr>
<td>7.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.SamplerTrigger\">
  SamplerTrigger</a>
</td>
</tr>
<tr>
<td>8.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Saw\">
  Saw</a>
</td>
</tr>
<tr>
<td>9.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Sine\">
  Sine</a>
</td>
</tr>
<tr>
<td>10.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Sqare\">
  Sqare</a>
</td>
</tr>
<tr>
<td>11.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Step\">
  Ramp</a>
</td>
</tr>
<tr>
<td>12.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Trapezoid\">
  Trapezoid</a>
</td>
</tr>
<tr>
<td>13.</td>
<td>
  <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Triangular\">
  Triangular</a>
</td>
</tr>
<tr><td colspan=2><b></br></b> </td></tr>
<tr><td colspan=2><b>Function Blocks</b></td></tr>
<tr>
<td>1.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Add\">Add</a>
</td>
</tr>
<tr>
<td>2.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.CommandedSampler\">CommandedSampler</a>
</td>
</tr>
<tr>
<td>3.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Comparator\">Comparator</a>
</td>
</tr>
<tr>
<td>4.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.CrossDetect\">CrossDetect</a>
</td>
</tr>
<tr>
<td>5.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Delay\">Delay</a>
</td>
</tr>
<tr>
<td>6.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Divider\">Divider</a>
</td>
</tr>
<tr>
<td>7.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Gain\">Gain</a>
</td>
</tr>
<tr>
<td>8.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Hold\">Hold</a>
</td>
</tr>
<tr>
<td>9.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Hysteresis\">Hysteresis</a>
</td>
</tr>
<tr>
<td>10.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Integrator\">Integrator</a>
</td>
</tr>
<tr>
<td>11.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Inverse\">Inverse</a>
</td>
</tr>
<tr>
<td>12.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Multiplier\">Multiplier</a>
</td>
</tr>
<tr>
<td>13.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Power\">Power</a>
</td>
</tr>
<tr>
<td>14.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Quantiser\">Quantiser</a>
</td>
</tr>
<tr>
<td>15.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Saturation\">Saturation</a>
</td>
</tr><tr>
<td>16.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Sin\">Sin</a>
</td>
</tr><tr>
<td>17.</td>
<td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks.Switch\">Switch</a>
</td>
</tr>
<tr><td colspan=2><b></br></b> </td></tr>
<tr><td colspan=2><b>Sink Blocks</b></td></tr>
<tr>
<td>1.</td><td><a href=\"Modelica://ModelicaDEVS.SinkBlocks.Interpolator\">Interpolator</a></td>
</tr>
<tr><td colspan=2><b></br></b> </td></tr>
<tr><td colspan=2><b>Miscellaneous</b></td></tr>
<tr>
<td>1.</td><td><a href=\"Modelica://ModelicaDEVS.Miscellaneous.WorldModel\">WorldModel</a></td>
</tr>
<tr><td colspan=2><b></br></b> </td></tr>
<tr><td colspan=2><b>Examples</b></td></tr>
<tr>
<td>1.</td><td><a href=\"Modelica://ModelicaDEVS.Examples.DifferentialEquation\">Differential equation</a></td>
</tr>
<tr>
<td>2.</td><td><a href=\"Modelica://ModelicaDEVS.Examples.Electrical.FlybackConverter\">Flyback converter circuit</a></td>
</tr>
<tr>
<td>3.</td><td><a href=\"Modelica://ModelicaDEVS.Examples.Electrical.SimpleCircuit\">Simple electrical circuit</a></td>
</tr>
<tr>
<td>4.</td><td><a href=\"Modelica://ModelicaDEVS.Examples.Miscellaneous.LotkaVolterra\">Lotka Volterra predator-prey model</a></td>
</tr>
<tr>
<td>5.</td><td><a href=\"Modelica://ModelicaDEVS.Examples.Miscellaneous.TwoLoops\">Two-loop model</a></td>
</tr>
<tr>
<td>6.</td><td><a href=\"Modelica://ModelicaDEVS.Examples.Miscellaneous.Stairball\">Ball bouncing down a stair</a></td>
</tr>
</table>
</p>
<br/>
<br/>
</html>"));
      end LibraryOverview;
    end ModelicaDEVS;

    package Literature "Literature"
    annotation (Documentation(info="<html>
<font color=\"#008000\" size=5><b>Literature</b></font>
<p>
The following books and papers provide more insight into topics related to the theory behind the ModelicaDEVS library.
</p>
</br>
<p>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td colspan=2><b>Modelling & Simulation in general</b> </td>
</tr>
<tr>
<td>[Cassandras99]</td>
<td>Cassandras, C.G. and S. Lafortune (1999), Introduction to discrete   event systems, Kluwer Academic Publishers, Boston.</td>
</tr>
<tr>
<td>[Kelton91] </td>
<td>Kelton, D.W. and A.M. Law (1991), Simulation Modeling and Analysis, McGraw-Hill, New York.</td>
</tr>
<tr><td colspan=2><b></br></b> </td></tr>
<tr><td colspan=2><b>Simulation & DEVS formalism</b></td></tr>
<tr>
<td>[Cellier91] </td>
<td>Cellier, F.E. (1991), Continuous System Modeling, Springer-Verlag, New York.</td>
</tr>
<tr>
<td>[Cellier05] </td>
<td>Cellier, F.E. and E. Kofman (2005), Continuous System Simulation, Springer-Verlag, New York.</td>
</tr>
<tr>
<td>[Concepcion88]</td>
<td>Concepcion, A.I. and Zeigler, B.P. (1988), \"DEVS Formalism: A Framework for Hierarchical Model Development,\" IEEE Trans Software Engineering, 14(2), pp. 228-241.</td>
</tr>
<tr>
<td>[Kofman01] </td>
<td>Kofman, E. and S. Junco (2001), Quantized State Systems. A DEVS Approach for Continuous Systems Simulation, Transactions of SCS. 18(3). pp.123-132.</td>
</tr>
<tr>
<td>[Kofman02] </td>
<td>Kofman, E., A Second Order Approximation for DEVS Simulation of Continuous  Systems, Simulation (Journal of The Society for Computer Simulation International), 78(2), pp 76-89.</td>
</tr>
<tr>
<td>[Kofman03] </td>
<td>Kofman, E., M. Lapadula, and E. Pagliero (2003), PowerDEVS: A DEVS-based Environment for Hybrid System Modeling and Simulation, Technical Report LSD0306, LSD, Universidad Nacional de Rosario, Argentinien. Submitted to Simulation.</td>
</tr>
<tr>
<td>[Kofman05] </td>
<td>Kofman, E., A Third Order Discrete Event Method for Continuous System Simulation. Part II: Applications. Technical Report LSD0502, LSD, Universidad Nacional de Rosario. Accepted in RPIC'05.</td>
</tr>
<tr>
<td>[Zeigler76]</td>
<td>Zeigler, B.P. (1976), Theory of Modelling and Simulation, Wiley, New York.</td>
</tr>
<tr>
<td>[Zeigler84]</td>
<td>Zeigler, B.P. (1984), Multifacetted Modelling and Discrete Event Simulation, Academic Press, London.</td>
</tr>
<tr>
<td>[Zeigler98]</td>
<td>Zeigler, B.P., J.S. Lee (1998), Theory of quantized systems: formal basis for DEVS/HLA distributed simulation environment, SPIE Proceedings, Vol. 3369, pp. 49-58.</td>
</tr>
<tr><td colspan=2><b></br></b> </td></tr>
<tr><td colspan=2><b>Dymola & Modelica</b></td></tr>
<tr>
<td>[Dymola] </td>
<td>Dymola User's Manual. Is distributed with the Dymola software, available in the folder \"Documentation\".</td>
</tr>
<tr>
<td>[Fritzson04] </td>
<td>Fritzson, P. (2004), Principles of Object-Oriented Modeling and Simulation with Modelica 2.1, Wiley Interscience.</td>
</tr>
<tr>
<td>[Modelica] </td>
<td>Modelica Tutorial (by the Modelica Association). Is distributed with the Dymola software, available in the folder \"Modelica/Documentation\" or available at \"http://www.modelica.org/documents/ModelicaTutorial14.pdf\".</td>
</tr>
<tr>
<td>[Tiller01]</td>
<td>Tiller, M.M. (2001), Introduction to Physical Modeling with Modelica, Kluwer Academic Publishers, Boston.</td>
</tr>
</table>
</p>
</html>"));
    end Literature;

  end UsersGuide;
  annotation (uses(Modelica(version="2.2"), ModelicaDEVS(version="1")),
    Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The ModelicaDEVS Library </b></font>
<br/>
<br/>
<p>
This package provides the tools for the simulation according to the <a href=\"Modelica://ModelicaDEVS.UsersGuide.DEVSformalism\"> DEVS formalism</a>.
<\\p>
<p>
A motivation for the implementation of this library as well as a brief theoretical introduction are given in the <a href=\"Modelica://ModelicaDEVS.UsersGuide\">User's Guide</a>.
<\\p>
<br/>
<br/>
<p>
The ModelicaDEVS library currently consists of the following subpackages (March 2006):
<\\p>
<p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><td><a href=\"Modelica://ModelicaDEVS.SourceBlocks\">SourceBlocks</a></td>
      <td>Source blocks</td>
  </tr>
  <tr><td><a href=\"Modelica://ModelicaDEVS.FunctionBlocks\">FunctionBlocks</a></td>
      <td>All blocks that are nor source blocks nor sink blocks. </td>
  </tr>
  <tr><td><a href=\"Modelica://ModelicaDEVS.SinkBlocks\">SinkBlocks</a></td>
      <td>Sink blocks. This subpackage actually contains just one block, namely the Interpolator.</td>
  </tr>
<tr><td><a href=\"Modelica://ModelicaDEVS.Miscellaneous\">Miscellaneous</a></td>
      <td>Components that facilitate the handling of a model</td>
  </tr>
<tr><td><a href=\"Modelica://ModelicaDEVS.Templates\">Templates</a></td>
      <td>Templates for connectors and the different types of DEVS components (single input/single output, only output, ...)</td>
  </tr>

<tr><td><a href=\"Modelica://ModelicaDEVS.Examples\">Examples</a></td>
      <td>Some of the examples that were used to test the library have been maintained in the final version in order to give an idea of possible types of simulation.</td>
  </tr>
</table>
<\\p>
</html>"),
  version="1",
  conversion(from(version="", script="ConvertFromDEVS_.mos")));

  package SourceBlocks "Source Blocks"
    block Constant "Generates a constant output signal."

      extends ModelicaDEVS.Templates.DSource(final method=3);
                                                             //valid for all QSS
      parameter Real v=0 "Constant value";

    protected
      Boolean dint;

    equation
      dint = time<=0;
      yEvent= edge(dint); //if time <=0 then true else false;

      when dint then
        yVal[1] = v;
        yVal[2] = 0; //slope is always zero
        yVal[3] = 0; //slope of the slope is always zero
      end when;

    initial equation
      yVal[1]=v;

    annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,30; 72,30], style(color=3, rgbcolor={0,0,255}))),
          Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Constant Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>v</b></td>
<td>constant value</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Constant block generates a constant signal.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1/QSS2/QSS3 mode):</font>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td colspan=2>The only output event is generated at time <b>t=0</b> and takes the value determined by <b>v</b>. </td>
</tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><img src=\"../Images/OutConstant.png\"></td>
<td>Parameter setting:</td>
<td>
v=1.5
</td>
</tr>
</table>
<br/>
</html>"));
    end Constant;

    block Pulse "Generates a pulse signal."

      extends ModelicaDEVS.Templates.DSource(final method=3);
                                                              //valid for all QSS

      parameter Real offset=0 "Pulse start value";
      parameter Real a=1 "Pulse amplitude";
      parameter Real ts=1 "Time pulse goes up";
      parameter Real tu=2 "Time pulse stays up";

    protected
      discrete Real sigma(start=0);
      discrete Real lastTime(start=0);
      Boolean dint(start=false);
      Boolean pulse(start=false);

    equation
      pulse= time >=ts and time <ts+tu;
      dint = time >= pre(lastTime)+pre(sigma);
      yEvent= edge(dint);

      when {dint} then
        yVal[1] = if pulse then offset+a else offset; //at time=ts+tu pulse goes down
        yVal[2]=0; //slope is always zero
        yVal[3]=0; //slope of the slope is always zero
        sigma= if time<=0 then ts else if pulse then tu else Modelica.Constants.inf;
        lastTime=time;
      end when;

    initial equation
      yVal[1]=offset;

      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-20; -28,-20; -28,60; 30,60; 30,-20; 70,-20], style(color=3,
                rgbcolor={0,0,255}))), Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Pulse Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>offset</b></td>
<td>pulse ground value</td>
</tr>
<tr>
<td><b>a</b></td>
<td>pulse amplitude</td>
</tr>
<tr>
<td><b>ts</b></td>
<td>pulse start time</td>
</tr>
<tr>
<td><b>tu</b></td>
<td>duration of pulse</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
This block generates a simple pulse signal.
<br/>
<br/>
Note that it is possible to assign a negative value to the amplitude, such that the pulse signal is rather an indentation than a bulge respective to the ground value (mirrored at the straight line y=offset).
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1/QSS2/QSS3 mode):</font>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=0</b></td>
<td>offset</td>
<td>0</td>
<td>0</td>
</tr>
<tr>
<td><b>t=ts</b></td>
<td>offset+a</td>
<td>0</td>
<td>0</td>
</tr>
<tr>
<td><b>t=ts+tu</b></td>
<td>offset</td>
<td>0</td>
<td>0</td>
</tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><img src=\"../Images/OutPulse.png\"></td>
<td>Parameter setting:</td>
<td>
offset=0.5 <br/>
a=1<br/>
ts=1<br/>
tu=1</td>
</tr>
</table>
<br/>
</html>"));
    end Pulse;

    block PWM
      "Compares a sine and a triangular signal. If sine is bigger, the output is vU and vL else."
      extends ModelicaDEVS.Templates.DSource(final method=3);
                                                              //valid for all QSS
      parameter Real as=1 "Amplitude of sine signal";
      parameter Real fs=1 "Frequency of sine";
      parameter Real at=1 "Amplitude of triangular signal";
      parameter Real ft=1 "Frequency of triangular signal";
      parameter Real vU=1 "Upper Value of PWM signal";
      parameter Real vL=-1 "Lower Value of PWM signal";

      Triangular Triangular1(k=100, f=ft, a=at,
        method=3)                         annotation (extent=[-40,-40; -20,-20]);
      FunctionBlocks.Comparator Comparator1(Vl=vL, Vu=vU,
        method=3)                             annotation (extent=[20,-10; 40,10]);
      annotation (Diagram, Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,0; -90,0; 78,0],       style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,70; -50,70; -50,-72; -42,-72; -42,70; -16,70; -16,-72; -14,-72;
                -14,70; 10,70; 10,-72; 14,-72], style(color=3, rgbcolor={0,0,255})),
          Line(points=[14,-72; 14,-58; 14,70; 34,70; 34,-72; 42,-72; 42,70; 54,70;
                54,-72; 74,-72; 74,70], style(color=3, rgbcolor={0,0,255}))),
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The PWM Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>as</b></td>
<td>amplitude of sine signal</td>
</tr>
<tr>
<td><b>fs</b></td>
<td>frequency of sine signal</td>
</tr>
<tr>
<td><b>at</b></td>
<td>amplitude of triangular signal</td>
</tr>
<tr>
<td><b>ft</b></td>
<td>frequency of triangular signal</td>
</tr>
<tr>
<td><b>vU</b></td>
<td>upper output value</td>
</tr>
<tr>
<td><b>vL</b></td>
<td>lower output value</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The PWM block generates a pulse width modulation signal defined by the comparison between a sine signal and a triangular signal.
<br/>
<br/>
This block is an example demonstrating the possibility to reuse models as blocks within other models: instead of programming the PWM signal explicitly, it is actually an assembly of three other blocks: a Sine source, a Triangular source and a Comparator. The functionality of these three blocks is packed into one block (the PWM block) which can be reused as a component in other models. The interior structure of the PWM block can be found when activating the diagram-view of the PWM block.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1/QSS2/QSS3 mode):</font>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr><td colspan=2>
Output is generated each time the two signals (sine/triangular) cross each other. If the sine signal is bigger than the triangular signal, the output takes a value of <b>vU</b>, and <b>vL</b> otherwise.
</td></tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><img src=\"../Images/OutPWM.png\"></td>
<td>Parameter setting:</td>
<td>
fs=1 <br/>
a=1<br/>
at=1<br/>
ft=16<br/>
vU=1<br/>
vL=-1</td>
</tr>
</table>
<br/>
</html>"));

      Sine Sine1(k=100, f=fs, a=as,
        method=3)       annotation (extent=[-40,20; -20,40]);

    equation
      connect(Sine1.outPort, Comparator1.inPort1) annotation (points=[-18,30; -6,30;
            -6,4; 18,4],      style(color=3, rgbcolor={0,0,255}));
      connect(Triangular1.outPort, Comparator1.inPort2) annotation (points=[-18,-30;
            -6,-30; -6,-4; 18,-4],   style(color=3, rgbcolor={0,0,255}));
      connect(Comparator1.outPort, outPort)
        annotation (points=[42,0; 120,0], style(color=3, rgbcolor={0,0,255}));
    end PWM;

    block Ramp "Generates a ramp signal."

      extends ModelicaDEVS.Templates.DSource;

      parameter Real offset=0.0 "Start value";
      parameter Real a=1.0 "Amplitude";
      parameter Real ts=1.0 "Time the ramp starts to rise";
      parameter Real tr=1.0 "Time the ramp needs to reach the final value";
      parameter Real k=10 "Outputs during ramp (only for QSS1)";

    protected
      discrete Real sigma(start=0);
      discrete Real q(start=offset);
      discrete Real lastTime(start=0);
      Real quantum=a/k;
      Boolean ramp(start=false); //checks if the system is "on the slope"
      Boolean dint(start=false);

    equation
      ramp = time >= ts and time <= ts+tr;
      dint = time >= pre(lastTime)+pre(sigma);
      yEvent= edge(dint);

      when {dint} then
        if method == 1 then
          yVal[1]= q;
          yVal[2]= 0;
          yVal[3]= 0;
          sigma=if time<=0 then ts else if ramp then tr/k else Modelica.Constants.inf;
          q=if time<=ts then offset else pre(q)+quantum;
        else
          yVal[1]= if time < ts+tr then offset else offset+a;
          yVal[2]= if time >= ts and time < ts+tr then a/tr else 0;
          yVal[3]= 0;

          sigma=if time<=0 then ts else if time >= ts and time < ts+tr then tr else Modelica.Constants.inf;
          q=pre(q); //dummy setting
        end if;
          lastTime = time;
      end when;

    initial equation
      yVal[1]=offset;

      annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Ramp Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>offset</b></td>
<td>signal ground value</td>
</tr>
<tr>
<td><b>a</b></td>
<td>amplitude</td>
</tr>
<tr>
<td><b>ts</b></td>
<td>start time (when the slope starts to rise)</td>
</tr>
<tr>
<td><b>tr</b></td>
<td>rise time (time the signal needs to reach the upper value)</td>
</tr>
<tr>
<td><b>k</b></td>
<td>number of outputs during the rise of the ramp (only for QSS1)</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Ramp block generates a simple ramp signal.
<br/>
<br/>
The easiest way of describing a ramp signal would be by a) indicating the time instance when the signal starts to rise and b) giving the slope of the trajectory. However, provided that it is not possible to indicate a slope in QSS1, the ramp trajectory has to be described by means of a piecewise constant function. To this end, it is broken into pieces, which allows the component to launch output events during the rise of the ramp signal. The number of outputs are determined by the parameter k.
<br/>
<br/>
For QSS2 and QSS3, on the other hand, the signal is described by means of a value and a slope, given that this possible in higher-order QSS modes.
<br/>
<br/>
Note that it is possible to assign a negative value to the amplitude, such that the ramp signal is mirrored at the straight line y=offset.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1 mode):</font>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=0</b></td>
<td>offset</td>
<td>0</td>
<td>0</td>
</tr>
<tr>
<td><b>t=ts+i*tr/k</b></td>
<td>offset+i*a/k</td>
<td>0</td>
<td>0</td>
</tr>
<tr><td><i>i={0,1,2,...,k}</i><td></tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><img src=\"../Images/OutRamp.png\"></td>
<td>Parameter setting:</td>
<td>
offset=0 <br/>
a=1<br/>
ts=1<br/>
tr=1<br/>
k=10</td>
</tr>
</table>
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS2/QSS3 mode):</font>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=0</b></td>
<td>offset</td>
<td>0</td>
<td>0</td>
</tr>
<tr>
<td><b>t=ts</b></td>
<td>offset</td>
<td>a/tr</td>
<td>0</td>
</tr>
<tr>
<td><b>t=ts+tr</b></td>
<td>offset+a</td>
<td>0</td>
<td>0</td>
</tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td>
<img src=\"../Images/OutRampQSS2-1.png\"><br/>
<img src=\"../Images/OutRampQSS2-2.png\">
</td>
<td>Parameter setting:</td>
<td>
offset=0 <br/>
a=1<br/>
ts=1<br/>
tr=1</td>
</tr>
</table>
<br/>
</html>"),     Icon(
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-24; -20,-24; 22,52; 72,52; 72,52; 72,52; 70,52], style(
                color=3, rgbcolor={0,0,255}))));
    end Ramp;

    block Saw "Generates a saw signal."
      extends ModelicaDEVS.Templates.DSource;

      parameter Real a=1.0 "Amplitude";
      parameter Real f=1.0 "Frequency";
      parameter Real k=10 "Number of outputs per period (only for QSS1)";

    protected
      discrete Real q(start=-a);
      discrete Real interval;
      Real quantum=2*a/(k-1);
      Integer count(start=0);
      Integer showEvents(start=0);

    equation
      yEvent= sample(0,interval);

      when initial() then //interval cannot be initialized in "initial equations" because it needs to be discrete (for the sample command) and discrete variables have to be updated in a when statement.
        interval= if method==1 then 1/f/k else 1/f;
      end when;

      when {sample(0,interval)} then
        if method ==1 then
          yVal[1]=pre(q);
          yVal[2]=0;
          yVal[3]=0;
          q=if pre(count) == k-1 then -a else pre(q)+quantum;
          count= if pre(count) == k-1 then 0 else pre(count)+1;
        else
          yVal[1]=-a;
          yVal[2]=2*a*f;
          yVal[3]=0;
          q=pre(q);         //dummy setting
          count=pre(count); //dummy setting
        end if;
        showEvents=pre(showEvents)+1;
      end when;

    initial equation
      yVal[1]=-a;

      annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Saw Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>a</b></td>
<td>amplitude</td>
</tr>
<tr>
<td><b>f</b></td>
<td>frequency</td>
</tr>
<tr>
<td><b>k</b></td>
<td>number of outputs during the rise of the ramp (only for QSS1)</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
This block generates a saw tooth like signal.
<br/>
<br/>
Again, QSS1 needs the signal to be described in terms of a piecewise constant stair function (see the description of the <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Ramp\">Ramp</a> block for more details).
<br/>
<br/>
Note that it is possible to assign a negative value to the amplitude, such that the saw signal is mirrored at the x-axis.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1 mode):</font>
<br/>
<br/>
Note: the following table descibes only <b>one period</b> of the signal.
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=i*1/(f*k)</b></td>
<td>-a+i*(2*a/(k-1))</td>
<td>0</td>
<td>0</td>
</tr>
<tr><td><i>i={0,1,2,...,k}</i><td></tr>
</table>
<br/>
As can be seen in the picture below, the saw signal starts with the lower value (-amplitude) at the beginning of a period, but takes the upper value (+amplitude) before the end of the period. The reason for this is that it is not possible to make it take the upper value exactly when the period is over, since at that time instant it also would have to take the lower value in order to start the next period. Thus, only the start or the end of a slope can take the theoretically correct value, but not both.
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><img src=\"../Images/OutSaw.png\"></td>
<td>Parameter setting:</td>
<td>
a=2<br/>
f=1<br/>
k=11</td>
</tr>
</table>
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS2/QSS3 mode):</font>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=i*1/f</b></td>
<td>-a</td>
<td>2af</td>
<td>0</td>
</tr>
<tr><td><i>i=natural numbers</i><td></tr>
</table>
<br/>
Since both the starting value and the slope are the same at every saw \"tooth\", the values of the first two entries in the output vector are constant. The signal can be reconstructed by means of the auxiliary variable Saw.showEvents that changes its value each time a new period starts.
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td>
<img src=\"../Images/OutSawAll.png\"><br/>
</td>
<td>Parameter setting:</td>
<td>
a=2<br/>
f=1</td>
</tr>
</table>
<br/>
</html>"),     Icon(
          Line(points=[-92,0; -90,0; 78,0],       style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-48; -24,52; -24,-48; 22,52; 22,-48; 72,52; 72,-50],
              style(color=3, rgbcolor={0,0,255}))));
    end Saw;

    block Sine "Generates a sine signal."
      extends ModelicaDEVS.Templates.DSource;

      parameter Real a= 1 "Amplitude";
      parameter Real f= 1 "Frequency";
      parameter Real phi= 0 "Phase in rad";
      parameter Real k= 20 "Sample events per period";
      parameter Real start= 0 "Sampling start time";

    protected
      Real w=2*f*Modelica.Constants.pi;

    equation
      yEvent=sample(start,1/f/k);

      when sample(start,1/f/k) then
        yVal[1]= a*sin(time*w+phi);
        yVal[2]=if method>1 then a*w*cos(time*w+phi) else 0;
        yVal[3]=if method>2 then -a*w*w*sin(time*w+phi)/2 else 0;
      end when;

      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,0; -90,0; 78,0],       style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,0; -61.6,34.2; -56.1,53.1; -51.3,66.4; -47.1,74.6; -42.9,
                79.1; -38.64,79.8; -34.42,76.6; -30.201,69.7; -25.98,59.4; -21.16,
                44.1; -16,22; -2.5,-30.8; 3,-50.2; 7.8,-64.2; 12,-73.1; 16.2,-78.4;
                20.5,-80; 24.7,-77.6; 28.9,-71.5; 33.1,-61.9; 37.9,-47.2; 44,-24.8;
                66,64], style(color=3, rgbcolor={0,0,255}))),
                                                DymolaStoredErrors,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Sine Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>a</b></td>
<td>amplitude</td>
</tr>
<tr>
<td><b>f</b></td>
<td>frequency</td>
</tr>
<tr>
<td><b>phi</b></td>
<td>phase</td>
</tr>
<tr>
<td><b>k</b></td>
<td>number of outputs during the rise of the ramp (only for QSS1)</td>
</tr>
<tr>
<td><b>start</b></td>
<td>start time of the output series</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The well known first three parameters describe the customary properties of a sine signal. The last two parameters are used to generate the output: since the signal has to be understandable by DEVS blocks, the originally continuous sine signal has to be broken down into events. <br/>
Parameter k declares how many outputs per period are desired (duration of a period = 1/f). These outputs can be seen as samples of a normal sine signal.
<br/>
Parameter start indicates when the output series starts. This enables a sampling of the sine signal not only at time instants t= 0+i*(1/(f*k)), i=non-negative integers, but also at time instants t=start+i*(1/(f*k)) where start is the sampling start time and acts as an offset to the multiples of 1/(f*k).
<br/>
<br/>
Assigning a negative value to the amplitude yields a mirroring of the signal at the x-axis.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1/QSS2/QSS3 mode):</font>
<br/>
<br/>
Note: the following table descibes only <b>one period</b> of the signal.
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=start+i*(1/f*k)</b></td>
<td>a*sin(t*w+phi)</td>
<td>a*w*cos(t*w+phi)</td>
<td>-a*w*w*sin(t*w+phi)/2</td>
</tr>
<tr><td><i>i={0,1,2,...,k}</i><td></tr>
<tr><td><i>w=2*f*Modelica.Constants.pi</i><td></tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td>
<img src=\"../Images/OutSineAll.png\"><br/>
</td>
<td>Parameter setting:</td>
<td>
a=1<br/>
f=1<br/>
phi=0<br/>
k=20<br/>
start=0</td>
</tr>
</table>
</html>"));
    end Sine;

    block Square "Generates a square signal."

      extends ModelicaDEVS.Templates.DSource(final method=3);
                                                              //valid for all QSS
      parameter Real offset=0.0 "Aplitude offset";
      parameter Real a=1.0 "Amplitude";
      parameter Real f=1.0 "Frequency";
      parameter Real d=50
        "The percentage of the cycle during which the system adopts the value of the positive amplitude";

    protected
      discrete Real sigma(start=0);
      discrete Real lastTime(start=0);
      discrete Real level(start=0);
      Boolean dint(start=false);

    equation
      dint= time >= pre(lastTime)+pre(sigma);
      yEvent=edge(dint);

      when {dint} then
        yVal[1]=offset+(2*pre(level)-1)*a;
        yVal[2]=0; //slope is always zero
        yVal[3]=0; //slope of the slope is always zero

        sigma=(d*pre(level)+(1-pre(level))*(100-d))/(100*f);
        level=1-pre(level);

        lastTime=time;
      end when;

    initial equation
      yVal[1]=offset-a;

      annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Square Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>offset</b></td>
<td>amplitude offset</td>
</tr>
<tr>
<td><b>a</b></td>
<td>amplitude</td>
</tr>
<tr>
<td><b>f</b></td>
<td>frequency</td>
</tr>
<tr>
<td><b>d</b></td>
<td>duty cycle (percentage)</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
This block generates a simple step signal.
<br/>
<br/>
The duty cycle indicates the percentage of the period in which the signal is positive, i.e. when the output event takes a value of y=offset+a.
<br/>
<br/>
Assigning a negative value to the amplitude results in a mirroring of the signal at the straight line y=offset.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1/QSS2/QSS3 mode):</font>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=i*1/f</b></td>
<td>offset-a</td>
<td>0</td>
<td>0</td>
</tr>
<tr>
<td><b>t=i*1/f+1/(f*(100-d))</b></td>
<td>offset+a</td>
<td>0</td>
<td>0</td>
</tr>
<tr><td><i>i=natural numbers</i><td></tr>
</table>
<br/>
In words: events are generated at the beginning of a every period and at the beginning of the duty cycle.
<br/>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><img src=\"../Images/OutSquare.png\"></td>
<td>Parameter setting:</td>
<td>
offset=0 <br/>
a=1<br/>
f=1<br/>
d=75</td>
</tr>
</table>
<br/>
</html>"),     Icon(
          Line(points=[-92,0; -90,0; 78,0],       style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-40,-54; -40,48; -2,48; -2,-54; 40,-54; 40,48; 78,48], style(
                color=3, rgbcolor={0,0,255})),
          Line(points=[-44,-54; -70,-54], style(color=3, rgbcolor={0,0,255}))));
    end Square;

    block Step "Generates a step signal."

      extends ModelicaDEVS.Templates.DSource(final method=3);
                                                              //valid for all QSS

      parameter Real offset=0 "Step start value";
      parameter Real a=1 "Step Amplitude";
      parameter Real ts=0 "Step Time";

    protected
      discrete Real sigma(start=0);
      discrete Real lastTime(start=0);
      Boolean dint(start=false);

    equation
      dint= time >= pre(lastTime)+pre(sigma);
      yEvent= edge(dint);

      when  dint then
        yVal[1] = if time < ts then offset else offset+a;
        yVal[2] = 0; //slope is always zero
        yVal[3] = 0; //slope of the slope is always zero
        lastTime=time;
        sigma= if time < ts then ts else Modelica.Constants.inf;
      end when;

    initial equation
      yVal[1] = offset;

      annotation (Icon(
          Line(points=[-70,-22; -16,-22; -16,58; 30,58; 30,58; 66,58], style(color=
                  3, rgbcolor={0,0,255})),
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0}))),
          Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Step Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>offset</b></td>
<td>step ground value</td>
</tr>
<tr>
<td><b>a</b></td>
<td>step amplitude</td>
</tr>
<tr>
<td><b>ts</b></td>
<td>step start time (when the signal executes the \"step\")</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
This block generates a simple step signal.
<br/>
<br/>
Note that it is possible to assign a negative value to the amplitude, such that the step signal is mirrored at the straight line y=offset.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1/QSS2/QSS3):</font>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=0</b></td>
<td>offset</td>
<td>0</td>
<td>0</td>
</tr>
<tr>
<td><b>t=ts</b></td>
<td>offset+a</td>
<td>0</td>
<td>0</td>
</tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><img src=\"../Images/OutStep.png\"></td>
<td>Parameter setting:</td>
<td>
offset=0 <br/>
a=1.5<br/>
ts=2<br/>
</td>
</tr>
</table>
<br/>
</html>"));
    end Step;

    block Trapezoid "Generates a trapezoid signal."

      extends ModelicaDEVS.Templates.DSource;

      parameter Real offset=0 "Ground value";
      parameter Real a=1.0 "Amplitude";
      parameter Real tr=1.0 "Time the signal needs to rise";
      parameter Real tf=1.0 "Time the signal needs to fall";
      parameter Real tu=1.0 "Time the signal stays up";
      parameter Real td=1.0 "Time the signal stays down";
      parameter Real k=10 "Number of outputs per slope (only for QSS1)";

    protected
      discrete Real sigma(start=0);
      discrete Real lastTime(start=0);
      discrete Real q(start=offset);
      Real quantum= a/k; //takes sign of amplitude
      Boolean dint(start=false);
      Integer count(start=0);
      Integer cycle(start=0); //0=rise, 1=up, 2=fall, 3=down

    equation
      dint= time >= pre(lastTime)+pre(sigma);
      yEvent= edge(dint);

      when {dint} then
        if method == 1 then
          yVal[1]=pre(q);
          yVal[2]=0;
          yVal[3]=0;
          q=if pre(cycle)==0 then pre(q)+quantum else if pre(cycle)==2 then pre(q)-quantum else pre(q);
          cycle= if (pre(cycle)==0 and pre(count) == k-1) or (pre(cycle)==2 and pre(count) == k-1) or (pre(cycle)==1) then  (pre(cycle)+1) else if (pre(cycle)==3) then 0 else pre(cycle);
          count= if pre(count) == k then 0 else pre(count)+1;
          sigma= if pre(cycle)==0 then tr/k else if pre(cycle)==1 then tu else if pre(cycle)==2 then tf/k else td;
        else
          yVal[1]=if pre(cycle)== 3 or pre(cycle)==0 then offset else offset+a;
          yVal[2]=if pre(cycle)== 0 then a/tr else if pre(cycle)==2 then -a/tf else 0;
          yVal[3]=0;
          cycle=if pre(cycle)==3 then 0 else pre(cycle)+1;
          sigma= if pre(cycle)==0 then tr else if pre(cycle)==1 then tu else if pre(cycle)==2 then tf else td;
          q=pre(q);         //dummy setting
          count=pre(count); //dummy setting
        end if;
        lastTime=time;
      end when;

    initial equation
      yVal[1]=offset;

      annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Trapezoid Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>offset</b></td>
<td>signal ground value</td>
</tr>
<tr>
<td><b>a</b></td>
<td>amplitude</td>
</tr>
<tr>
<td><b>tr</b></td>
<td>rise time (how long does it take to reach the upper value)</td>
</tr>
<tr>
<td><b>tf</b></td>
<td>fall time (how long does it take to reach the lower value)</td>
</tr>
<tr>
<td><b>tu</b></td>
<td>time up (how long does the signal stay on the upper value)</td>
</tr>
<tr>
<td><b>td</b></td>
<td>time down (how long does the signal stay on the lower value)</td>
</tr>
<tr>
<td><b>k</b></td>
<td>number of outputs during the rise of the slopes (only for QSS1)</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
This block generates a trapezoidal signal.
<br/>
<br/>
Again, QSS1 needs the signal to be described in terms of a piecewise constant stair function (see the description of the <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Ramp\">Ramp</a> block for more details).
<br/>
<br/>
Note that it is possible to assign a negative value to the amplitude, such that the trapezoidal signal is mirrored at the straight line y=offset.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1 mode):</font>
<br/>
<br/>
<br/>
Note: the following table descibes only <b>one period</b> of the signal.
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=i*tr/k</b></td>
<td>i*a/k</td>
<td>0</td>
<td>0</td>
</tr>
<tr>
<td><b>t=(tr+tu)+i*tf/k</b></td>
<td>i*a/k</td>
<td>0</td>
<td>0</td>
</tr>
<tr><td><i>i={0,1,2,...,k}</i><td></tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><img src=\"../Images/OutTrapez.png\"></td>
<td>Parameter setting:</td>
<td>
offset=0<br/>
a=1<br/>
tr=2<br/>
tf=0.5<br/>
tu=0.5<br/>
td=1<br/>
k=10</td>
</tr>
</table>
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS2/QSS3 mode):</font>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=i*(tr+tu+tf+td)</b></td>
<td>offset</td>
<td>a/tr</td>
<td>0</td>
</tr>
<tr>
<td><b>t=tr+i*(tr+tu+tf+td)</b></td>
<td>a</td>
<td>0</td>
<td>0</td>
</tr>
<tr>
<td><b>t=tr+tu+i*(tr+tu+tf+td)</b></td>
<td>a</td>
<td>-a/tf</td>
<td>0</td>
</tr>
<tr>
<td><b>t=tr+tu+tf+i*(tr+tu+tf+td)</b></td>
<td>offset</td>
<td>0</td>
<td>0</td>
</tr>
<tr><td><i>i=natural numbers</i><td></tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td>
<img src=\"../Images/OutTrapezAll.png\">
</td>
<td>Parameter setting:</td>
<td>
offset=0<br/>
a=1<br/>
tr=2<br/>
tf=0.5<br/>
tu=0.5<br/>
td=1</td>
</tr>
</table>
<br/>
</html>"),     Icon(
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-30; -42,58; -6,58; 18,-30; 52,-30; 70,58; 84,58], style(
                color=3, rgbcolor={0,0,255}))));
    end Trapezoid;

    block Triangular "Generates a triangular signal."

      extends ModelicaDEVS.Templates.DSource;

      parameter Real a=1.0 "Amplitude";
      parameter Real f=1 "Frequency";
      parameter Real k=10 "Number of outputs per slope (only for QSS1)";

    protected
      discrete Real sign(start=1); //positive or negative slope
      discrete Real q(start=-a);
      discrete Real interval;
      Real quantum=2*a/k;
      Integer count(start=0);

    equation
      yEvent= sample(0,interval);

      when initial() then //interval cannot be initialized in "initial equations" because it needs to be discrete (for the sample command) and discrete variables have to be updated in a when statement.
        interval= if method==1 then 1/(2*f*k) else 1/(2*f);
      end when;

      when (sample(0,interval)) then
        if method == 1 then
          yVal[1]=pre(q);
          yVal[2]=0;
          yVal[3]=0;
          q=pre(q)+(quantum*pre(sign));
          sign= if pre(count) == k-1 then -pre(sign) else pre(sign);
          count= if pre(count) == k-1 then 0 else pre(count)+1;
        else
          yVal[1]=a*sign;
          yVal[2]=-4*a*f*sign;
          yVal[3]=0;
          sign=-pre(sign);
          q=pre(q);         //dummy setting
          count=pre(count); //dummy setting
        end if;
      end when;

    initial equation
      yVal[1]=-a;

      annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Triangular Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>a</b></td>
<td>amplitude</td>
</tr>
<tr>
<td><b>f</b></td>
<td>frequency</td>
</tr>
<tr>
<td><b>k</b></td>
<td>number of outputs per slope (only for QSS1)</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
This block generates a triangular signal.
<br/>
<br/>
Again, QSS1 needs the signal to be described in terms of a piecewise constant stair function (see the description of the <a href=\"Modelica://ModelicaDEVS.SourceBlocks.Ramp\">Ramp</a> block for more details).
<br/>
<br/>
Assigning a negative value to the amplitude yields a mirroring of the signal at the x-axis.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1 mode):</font>
<br/><br/>
<br/>
Note: the following table describes only <b>one period</b> of the signal.
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=i*1/(2*f*k)</b></td>
<td>-a+i*(2*a/k)</td>
<td>0</td>
<td>0</td>
</tr>
<tr>
<td><b>t=1/(2*f)+i*1/(2*f*k)</b></td>
<td>a-i*(2*a/k)</td>
<td>0</td>
<td>0</td>
</tr>
<tr><td><i>i={0,1,2,...,k}</i><td></tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><img src=\"../Images/OutTriangular.png\"></td>
<td>Parameter setting:</td>
<td>
a=1<br/>
f=1<br/>
k=20</td>
</tr>
</table>
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS2/QSS3 mode):</font>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td></td>
<td><b>yVal[1]</b></td>
<td><b>yVal[2]</b></td>
<td><b>yVal[3]</b></td>
</tr>
<tr>
<td><b>t=i*1/f</b></td>
<td>-a</td>
<td>4*a/f</td>
<td>0</td>
</tr>
<tr>
<td><b>t=1/(2*f)+i*1/f</b></td>
<td>a</td>
<td>-4*a/f</td>
<td>0</td>
</tr>
<tr><td><i>i=non-negative integers</i><td></tr>
</table>
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td>
<img src=\"../Images/OutTriangularQSS2-1.png\"><br/>
<img src=\"../Images/OutTriangularQSS2-2.png\"><br/>
</td>
<td>Parameter setting:</td>
<td>
a=1<br/>
f=1</td>
</tr>
</table>
<br/>
</html>"),     Icon(
          Line(points=[-92,0; -90,0; 78,0],       style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-74; -30,72; 26,-74; 66,74], style(color=3, rgbcolor={0,
                  0,255}))));
    end Triangular;

    block SamplerLevel
      "Samples a signal at the time instant when it crosses certain levels."
      extends ModelicaDEVS.Templates.CDBlock;

      parameter Real quantum= 0.1 "Quantum";

    protected
      discrete Real xl(start=0);
      discrete Real xu(start=quantum);
      Boolean bigger(start=false);
      Boolean smaller(start=false);
      Real derivative;

    equation
      bigger= u>=pre(xu);
      smaller= u<pre(xl);
      derivative=der(u);

      yEvent= change(bigger) or change(smaller);

      when {change(bigger), change(smaller)} then
        yVal[1]=floor(u/quantum)*quantum;
        yVal[2]=if method>1 then derivative else 0;
        yVal[3]=if method>2 then der(derivative)/2 else 0; // trick to get der(der(u));
        xu= if bigger then pre(xu)+quantum else pre(xu)-quantum;
        xl= xu-quantum;
      end when;

      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-14; -30,-14; -30,20; 10,20; 10,66; 66,66],   style(
                color=3, rgbcolor={0,0,255})),
          Line(points=[10,66; -70,66], style(
              color=71,
              rgbcolor={85,170,255},
              pattern=3)),
          Line(points=[-30,20; -70,20], style(
              color=71,
              rgbcolor={85,170,255},
              pattern=3))),                     DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The SamplerLevel Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>quantum</b></td>
<td>quantisation degree</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The purpose of the SamplerLevel block is to take a continuous signal and to transform it into a signal that is understandable by the DEVS components. To this end, the continuous input signal has to be transformed into events. In the case of the SamplerLevel block, the event instants are given by the points in time when the continuous signal reaches a new quantum level. The quantum levels can be thought to \"slice\" the original signal trajectory into horizontal stripes.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1/QSS2/QSS3 mode):</font>
<br/>
<br/>
The event instants are not predictable without knowing the continuous input signal. The only information we have about the output event vectors is that their yVal[1] value is a multiple of the quantum. The values of yVal[2] and yVal[3] are the first derivative and the second derivative devided by two of the damped sine signal at the given event instant.
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr><td><center><img src=\"../Images/OutSamplerLevel-setup.png\"></center></td></tr>
<tr>
<td><img src=\"../Images/OutSamplerLevel.png\"></td>
<td>Parameter setting:</td>
<td>
q=0.2
</tr>
</table>
<br/>
</html>"));
    end SamplerLevel;

    block SamplerTime "Samples a signal at periodical time instants."
      extends ModelicaDEVS.Templates.CDBlock;

      parameter Real period= 0.1 "Period";
      parameter Real start= 0 "Start Time";

    protected
      Real derivative;

    equation
      derivative=der(u); //used to produce der(der(u))
      yEvent= sample(start,period);

      when sample(start,period) then
        yVal[1]= u;
        yVal[2]= if method>1 then derivative else 0;
        yVal[3]= if method>2 then der(derivative)/2 else 0;
      end when;

      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-14; -30,-14; -30,20; 10,20; 10,66; 66,66],   style(
                color=3, rgbcolor={0,0,255})),
          Line(points=[-30,-14; -30,-50], style(
              color=71,
              rgbcolor={85,170,255},
              pattern=3)),
          Line(points=[10,20; 10,-50], style(
              color=71,
              rgbcolor={85,170,255},
              pattern=3))),                     DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The SamplerTime Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>period</b></td>
<td>length of the sampling intervals</td>
</tr>
<tr>
<td><b>start</b></td>
<td>start time of the sampling period</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
Analogous to the <a href=\"Modelica://ModelicaDEVS.SourceBlocks.SamplerLevel\">SamplerLevel</a> block, the SamplerTime block transforms a continuous signal into a DEVS signal. This time, though, the sampling takes place at discrete time instants.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1/QSS2/QSS3 mode):</font>
<br/>
<br/>
Samplings are taken at time instants <b>t=start+i*period</b>, i=non-negative integers. The values of the output vector cannot be predicted, since they depend on the input signal.
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr><td><center><img src=\"../Images/OutSamplerTime-setup.png\"></center></td></tr>
<tr>
<td><img src=\"../Images/OutSamplerTime.png\"></td>
<td>Parameter setting:</td>
<td>
period=0.05<br/>
start=0
</tr>
</table>
<br/>
</html>"));
    end SamplerTime;

    block SamplerTrigger "Samples a signal at given time instants."
      extends ModelicaDEVS.Templates.CDBlockSpecial;

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      discrete Real e; //how long has the system been in this state yet?
      Real derivative(start=0);
      discrete Real in1(start=0);
      discrete Real in2(start=0);
      discrete Real in3(start=0);
      Boolean dext;
      Boolean dint;

    equation
      derivative= der(u);

      dext= uEvent;
      dint = time>=pre(lastTime)+pre(sigma);
      yEvent= edge(dint);

      when dint then //update signals
        yVal[1]= in1;
        yVal[2]= in2;
        yVal[3]= in3;
      end when;

      when {dext} then
        in1 = u;
        in2= derivative;
        in3= der(derivative)/2;
        lastTime=time;
      end when;

      when {dint, dext} then
        e=time-pre(lastTime);
        sigma= if dint then Modelica.Constants.inf else 0;
      end when;

      annotation (Icon(
          Line(points=[-100,0; -32,0; 20,44], style(color=3, rgbcolor={0,0,255})),
          Ellipse(extent=[-36,4; -28,-4], style(color=3, rgbcolor={0,0,255})),
          Ellipse(extent=[30,4; 38,-4], style(color=3, rgbcolor={0,0,255})),
          Line(points=[100,0; 34,0], style(color=3, rgbcolor={0,0,255}))),
                          Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The SamplerTrigger Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>none</b></td>
<td></td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
Analogous to the <a href=\"Modelica://ModelicaDEVS.SourceBlocks.SamplerLevel\">SamplerLevel</a> block, the SamplerTrigger block transforms a continuous signal into a DEVS signal. The sampling takes place at discrete time instants which are given by an additional ModelicaDEVS block.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Generated Events</b> (QSS1/QSS2/QSS3 mode):</font>
<br/>
<br/>
Neither the event instants nor the event values can be predicted, because the event instants depend on the output of the ModelicaDEVS component connected to the discrete input port, and the event values depend on the continuous input signal.
<br/>
<br/>
<br/>
<table border=0 cellspacing=0 cellpadding=1>
<tr><td><center><img src=\"../Images/OutSamplerTrigger-setup.png\"></center></td></tr>
<tr>
<td><img src=\"../Images/OutSamplerTrigger.png\"></td>
<td></td>
<td></td>
</tr>
</table>
<br/>
</html>"));
    end SamplerTrigger;

    annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Source Blocks</b></font>
<br/>
<br/>
Currently, there are 13 source blocks available, whereby ten of them are \"genuine\" source blocks and the rest are transformator blocks that take input signals from non-DEVS models and transform them into signals that can be processed by subsequent DEVS blocks. Despite the fact that these components are not sources in a strict sense of the word (a source block is a block that does not take input but only generates output), they are located in the SourceBlocks package since they act as sources to components in the ModelicaDEVS library. The fact that they accept standard Modelica signals is not visible to a ModelicaDEVS model: there is no possibility to send a DEVS signal to a transformator block which makes them look like source blocks to ModelicaDEVS components.
<br/>
<br/>
Note that the signals generated by \"genuine\" source blocks could also be obtained by taking the corresponding components from the standard Modelica library and transform their output by one of the transformator blocks (SamplerLevel, SamplerTime and SamplerTrigger).
<br/>
<br/>
Every block in the SourceBlocks package generates a signal of a certain basic shape (which is indicated by the block's name, such as \"sine\", \"step\", \"triangular\", and many others. This basic shape can then be adjusted to the needs of the modeller by means of parameters that provide the possibility to set values for the amplitude, the frequency, and so on.
<br/>
<br/>
The source blocks are described by means of a listing of their parameters and the output they generate. Since it could be important for a certain situation to know when exactly what output values are generated, a comprehensive description of the output by means of the indication of creation time and value of the single events is provided.
<br/>
<br/>
Additionally, there is a short textual description, in order to cover possible particularities.
</html>"));
  end SourceBlocks;

  package FunctionBlocks "Function Blocks"
    block Add "Sums up two values."
      extends ModelicaDEVS.Templates.DoubleDDBlock;
      parameter Real c0=1 "|Coefficients||u0";
      parameter Real c1=1 "|Coefficients||u1";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      discrete Real e; //how long has the system been in this state yet?
      discrete Real newVal11(start=0);
      discrete Real newVal12(start=0);
      discrete Real newVal13(start=0);
      discrete Real newVal21(start=0);
      discrete Real newVal22(start=0);
      discrete Real newVal23(start=0);
      Boolean dext1;
      Boolean dext2;
      Boolean dint;

    equation
      dext1= uEvent1;
      dext2= uEvent2;
      dint = time>=pre(lastTime)+pre(sigma);
      yEvent= edge(dint);

      when dint then
        yVal[1]= c0*pre(newVal11) + c1*pre(newVal21);
        yVal[2]= if method>1 then c0*pre(newVal12) + c1*pre(newVal22) else 0;
        yVal[3]= if method>2 then c0*pre(newVal13) + c1*pre(newVal23) else 0;
      end when;

      when {dint, dext1, dext2} then
        e=time-pre(lastTime);
        newVal11= if dint then pre(newVal11) else if dext1 then uVal1[1] else pre(newVal11)+pre(newVal12)*e+pre(newVal13)*e*e;
        newVal12= if dint then pre(newVal12) else if dext1 then uVal1[2] else pre(newVal12)+2*pre(newVal13)*e;
        newVal13= if dint then pre(newVal13) else if dext1 then uVal1[3] else pre(newVal13);
        newVal21= if dint then pre(newVal21) else if dext2 then uVal2[1] else pre(newVal21)+pre(newVal22)*e+pre(newVal23)*e*e;
        newVal22= if dint then pre(newVal22) else if dext2 then uVal2[2] else pre(newVal22)+2*pre(newVal23)*e;
        newVal23= if dint then pre(newVal23) else if dext2 then uVal2[3] else pre(newVal23);
        sigma=if dint then Modelica.Constants.inf else 0;
        lastTime=time;
      end when;

    initial equation
    // initial equations needed because yVal[1] depends on pre()
      newVal11=uVal1[1];
      newVal12=uVal1[2];
      newVal13=uVal1[3];
      newVal21=uVal2[1];
      newVal22=uVal2[2];
      newVal23=uVal2[3];

      annotation (Icon(Text(
            extent=[-74,72; 80,-66],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillPattern=1),
            string="+")), Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Add Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>c0</b></td>
<td>coefficient of the first input value</td>
</tr>
<tr>
<td><b>c1</b></td>
<td>coefficient of the second input value</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Add block belongs to the binary operators and computes the weighted sum of two values:y=u0*c0+u1*c1.
<br/>
<br/>
The mechanism of a binary operator block is divided into two parts: a first part that becomes active at the occurrence of an internal event, and a second part that is activated by an internal as well as an external event:
<ul>
<li>
The first when-statement can be simply thought of as the analogon to the lambda output function.
</li>
<li>
The second when-statement represents the external and the internal transition. It shows one of the typical properties of the binary operator blocks: usually, only one of the two input ports receives a new signal whereas the other one remains silent, i.e. still holds the value that it had adopted the last time it received a signal. The evaluation of the output of the Add block could now simply depend on the old value of the inactive port and the new value that has arrived through the active one. However, in order to make the computation as accurate as possible, the old value of the silent port is replaced with an estimation of a value that the signal coming in through the silent port is likely to have adopted in the meantime (since the last time when there was an explicit external event). The estimation is carried out on the basis of the signal's previous Taylor series values (the coefficients to the constant, linear and quadratic terms).
<br/>
The following figure shows an example of possible inputs and outputs at the ports of an Add block. For the input signals, the current value as well as the coefficient of the first derivative (which is equal to the linear term of the Taylor series expansion) of the input function are graphically indicated. The output graph labelled \"output\" gives the true output involving the estimated value for silent ports. The graph labelled \"alternative output\" shows what the output would look like if no estimation for the function coming in through the silent port took place (which is the case in QSS1 where no higher-order Taylor series expansion is used).
<br/>
<br/>
<center><img src=\"../Images/AddWork.png\" width=\"400\"></center>
</li>
</ul>
</html>"));
    end Add;

    block CommandedSampler "Samples a signal at given time instants."
      extends ModelicaDEVS.Templates.DoubleDDBlock;

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      discrete Real e; //how long has the system been in this state yet?
      discrete Real u(start=0);
      discrete Real mu(start=0);
      discrete Real pu(start=0);
      Boolean dext1;
      Boolean dext2;
      Boolean dint;

    equation
      dext1= uEvent1;
      dext2= uEvent2;
      dint = time>=pre(lastTime)+pre(sigma);
      yEvent= edge(dint);

      when dint then
        yVal[1]= pre(u);
        yVal[2]= if method>1 then pre(mu) else 0;
        yVal[3]= if method>2 then pre(pu) else 0;
      end when;

      when {dint, dext1, dext2} then
        e=time-pre(lastTime);
        u = if dint then pre(u) else if dext1 then uVal1[1] else pre(u) + pre(mu)*pre(sigma) + pre(pu)*pre(sigma)*pre(sigma);
        mu= if dint then pre(mu) else if dext1 then uVal1[2] else pre(mu) + 2*pre(pu)*pre(sigma);
        pu= if dint then pre(pu) else if dext1 then uVal1[3] else pre(pu);
        sigma= if dint then Modelica.Constants.inf else if dext2 then 0 else pre(sigma)-e;
        lastTime=time;
      end when;

      annotation (Icon(
          Line(points=[100,0; 34,0], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-100,0; -32,0; 20,44], style(color=3, rgbcolor={0,0,255})),
          Ellipse(extent=[30,4; 38,-4], style(color=3, rgbcolor={0,0,255})),
          Ellipse(extent=[-36,4; -28,-4], style(color=3, rgbcolor={0,0,255}))),
                          Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The CommandedSampler Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>none</b></td>
<td></td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The CommandedSampler is fairly similar to the <a href=\"Modelica://ModelicaDEVS.FunctionBlocks.SamplerTrigger\"> SamplerTrigger</a> block. It takes two inputs where the first input is the signal from which the samples are taken, and the second input specifies the time instants when the sampling takes place. The second input is an arbitrary ModelicaDEVS block that generates a number of events, as it is in the nature of DEVS models. Usually, it is the values of the single events that we are interested in, given that they constitute the output trajectory. In this case however, for the CommandedSampler block to function correctly, it is only important to have <b>any</b> events at certain time instants: when the CommandedSampler receives an event from its second input port, it immediately takes a sample from the signal coming in through the first input port and holds this value until the next event is arriving at its second input port.
<br/>
Note that both input signals are discrete-time variables in terms of Modelica, i.e. they are piecewise constant.
<br/>
<br/>
Normally, the sampling instants do not coincide with the event instants of the first port. This means that at a given sampling instant, the signal from the first port has been updated a certain amount of time ago and may have changed meanwhile (without producing an output event). Hence, analogously to the binary operator blocks (Add, Divider, Multiplier), an approximation of the first input port's true value is estimated (on the basis of the linear and quadratic terms of the Taylor series expansion stored in the second and third entry of the input/output vecors).
<br/>
<br/>
The picture illustrating the behaviour of the CommandedSampler shows a Sine block (blue) and a Ramp block (green) connected to the input ports of the CommandedSampler. The Sine gives the signal that has to be sampled, the Ramp block (used in QSS1-mode) determines the sampling instants: we know that every time the Ramp block changes its output value, there must have been an event. Hence, at each of these event instants, the output of the CommandedSampler block (plotted in red) takes the current value of the Sine signal, since it has been triggered by the event sent by the Ramp block to do so.
<br/>
<br/>
<center><img src=\"../Images/OutCommandedSampler.png\"></center>
</html>"));
    end CommandedSampler;

    block Comparator
      "Compares two input signals: if input1 > input2 -> emits upper output value, if input1 <= input2 -> emits lower output value"
      extends ModelicaDEVS.Templates.DoubleDDBlock;
      parameter Real Vu=2 "Upper output value (if input 1 > input 2).";
      parameter Real Vl=1 "Lower output value (if input 1 <= input 2).";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      discrete Real tcross(start=Modelica.Constants.inf);
      discrete Real e; //how long has the system been in this state yet?
      discrete Real u[2](start={0,0}); //current Input value
      discrete Real mu[2](start={0,0}); //first derivative of u
      discrete Real pu[2](start={0,0}); //second derivative of u
      discrete Real sw(start=-1);
      discrete Real a;
      discrete Real b;
      discrete Real c;
      discrete Real s1;
      discrete Real s2;
      Boolean dext1;
      Boolean dext2;
      Boolean dint;

    equation
      dext1= uEvent1;
      dext2= uEvent2;
      dint = time>=pre(lastTime)+pre(sigma);

      when dint and not dext1 and not dext2 then  //true only if not dext
        yVal[1]=if (pre(sigma) == 0 and pre(sw)==1) or (pre(sigma)<>0 and (1-pre(sw))==1) then Vl else Vu;
        yVal[2]=0;
        yVal[3]=0;
      end when;
        yEvent= edge(dint);

      when {dext1, dext2} then
        a=pu[1]-pu[2];
        b=mu[1]-mu[2];
        c=u[1]-u[2];
        if a==0 then
          if b==0 then
            s1=Modelica.Constants.inf;
            s2=Modelica.Constants.inf;
          else
            s1=-c/b;
            s2=Modelica.Constants.inf;
          end if;
        else
          if b*b-4*a*c > 0 then
            s1=(-b+sqrt(b*b-4*a*c))/2/a;
            s2=(-b-sqrt(b*b-4*a*c))/2/a;
          else
            s1=Modelica.Constants.inf;
            s2=Modelica.Constants.inf;
          end if;
        end if;
      end when;

      when {dext1, dext2, dint} then
        e=time-pre(lastTime);
        if dint and not dext1 and not dext2 then  //execute dext first!!
          u[1] = if pre(sigma)<>0 then pre(u[1])+pre(mu[1])*pre(sigma)+pu[1]*pre(sigma)^2 else pre(u[1]);
          mu[1]= if pre(sigma)<>0 then pre(mu[1])+2*pu[1]*pre(sigma) else pre(mu[1]);
          pu[1]= pre(pu[1]);
          u[2] = if pre(sigma)<>0 then pre(u[2])+pre(mu[2])*pre(sigma)+pu[2]*pre(sigma)^2 else pre(u[2]);
          mu[2]= if pre(sigma)<>0 then pre(mu[2])+2*pu[2]*pre(sigma) else pre(mu[2]);
          pu[2]= pre(pu[2]);
          sw   = if pre(sigma)<>0 then if mu[1]<mu[2] then 1 else 0 else pre(sw);
          sigma= if pre(sigma)<>0 then if (mu[1]-mu[2])*(pu[1]-pu[2])<0 then (mu[2]-mu[1])/(pu[1]-pu[2]) else Modelica.Constants.inf else pre(tcross);
          tcross=if pre(sigma)<>0 then if (mu[1]-mu[2])*(pu[1]-pu[2])<0 then (mu[2]-mu[1])/(pu[1]-pu[2]) else Modelica.Constants.inf else pre(tcross);

      else //dext

          u[1] = if dext1 then uVal1[1] else pre(u[1])+pre(mu[1])*e+pre(pu[1])*e*e;
          mu[1]= if dext1 then uVal1[2] else pre(mu[1])+2*pre(pu[1])*e;
          pu[1]= if dext1 then uVal1[3] else pre(pu[1]);
          u[2] = if dext2 then uVal2[1] else pre(u[2])+pre(mu[2])*e+pre(pu[2])*e*e;
          mu[2]= if dext2 then uVal2[2] else pre(mu[2])+2*pre(pu[2])*e;
          pu[2]= if dext2 then uVal2[3] else pre(pu[2]);

          if pre(sigma) == e then //dint was true, too.
            sw=pre(sw);
            sigma = 0;
          else
            if pre(sw)==-1 then
              if (u[1]-u[2]>0) then
                sw=0;
                sigma=0;
              else
                sw=1;
                sigma=0;//tcross
              end if;
            else
              if ((u[1]-u[2]>0) and (pre(sw)==1)) or ((u[1]-u[2]<=0) and (pre(sw)==0)) then //crossing time instant found
                sw=1-pre(sw);
                sigma=0;
              else
                sw=pre(sw);
                sigma=tcross;
              end if;
            end if;
          end if;
          tcross= if s1>0 and ((s1<s2) or (s2<0)) then s1 else if s2>0 then s2 else Modelica.Constants.inf;
        end if;
        lastTime=time;
      end when;

    initial equation
      yVal[1]=if uVal1[1] > uVal2[1] then Vu else Vl;
      annotation (Icon(Text(
            extent=[-72,86; 82,-52],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillPattern=1),
            string="<"),
                       Text(
            extent=[-72,42; 82,-96],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillPattern=1),
            string=">")), Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Comparator Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>vU</b></td>
<td>upper output value</td>
</tr>
<tr>
<td><b>vL</b></td>
<td>lower output value</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
This block compares two input signals and produces an output event carrying a value that depends on the result of the comparison.
The user is invited to specify an \"upper\" and a \"lower\" output value (vU and vL). Then, if the first input signal is bigger than the second one, the output takes the value of vU, and vL otherwise.
<br/>
<br/>
It is the only component that in case of concurrent transitions (cf. the <a href=\"Modelica://ModelicaDEVS.UsersGuide.Theory\"> ModelicaDEVS Theory</a> section) executes the external transition before the internal one. This has the following reason: at each event instant, the comparator estimates the moment when the two input signals will cross the next time (the estimation makes use of the linear and quadratic terms of the Taylor series expansion). The chronological distance between the current and the next event is represented by the variable sigma. Suppose now the time instant when the two signals are supposed to cross has arrived. If simultaneously, one of the signals updates its value, it is of course more advantageous to use this new, true value instead of relying on the estimated one. Therefore, in case of concurrent internal and external transitions, the external transition is more important to process, because the values on which the scheduling of the internal transition has been calculated may have become outdated.
<br/>
Note that because of the reversed priority order of the internal and the external transition, the Comparator block may not be connected in a cycle with itself, unless there is another component in between that breaks the algebraic loop (again, see the <a href=\"Modelica://ModelicaDEVS.UsersGuide.Theory\">Theory</a> section for details on algebraic loops).
<br/>
<br/>
The picture below shows the output of a Comparator (red) that compares a sine signal (blue) and the output of a Ramp block (green) run in QSS1-mode, such that there are output events during the ramp. vU and vL have been set to 2 and 1.5 respectively.
<br/>
<br/>
<center><img src=\"../Images/OutComparator.png\"></center>
</html>"));
    end Comparator;

    block CrossDetect
      "Detects the crossing instant of the input signal with a given level."
      extends ModelicaDEVS.Templates.DDBlock;
      parameter Real level=0 "Switching level.";
      parameter Real vOut=2 "Output value at event instants.";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      discrete Real e; //how long has the system been in this state yet?
      discrete Real u;
      discrete Real mu;
      discrete Real pu;
      discrete Real tcross(start=Modelica.Constants.inf);
      discrete Real ch(start=0);
      discrete Integer sw(start=0);
      discrete Real s1;
      discrete Real s2;
      Boolean dext;
      Boolean dint;
      Integer showEvents(start=0);

    equation
      dint= time >= pre(lastTime)+pre(sigma);
      dext= uEvent;
      yEvent=edge(dint);

      when dint then
        yVal[1]=vOut;
        yVal[2]=0;
        yVal[3]=0;
        showEvents=pre(showEvents)+1;
      end when;

      when {dext} then //prepare variables s1 and s2 to compute sigma
        if pu==0 then
          if mu==0 then
            s1=Modelica.Constants.inf;
            s2=Modelica.Constants.inf;
          else
            s1=-(u-level)/mu;
            s2=Modelica.Constants.inf;
          end if;
        else
          if mu*mu-4*pu*(u-level) > 0 then
            s1=(-mu+sqrt(mu*mu-4*pu*(u-level)))/2/pu;
            s2=(-mu-sqrt(mu*mu-4*pu*(u-level)))/2/pu;
          else
            s1=Modelica.Constants.inf;
            s2=Modelica.Constants.inf;
          end if;
        end if;
      end when;

      when {dint, dext} then
        e=time-pre(lastTime);
        if dint then
          u = if pre(sigma)<>0 then pre(u) + pre(mu)*pre(sigma) + pre(pu)*pre(sigma)*pre(sigma) else pre(u);
          mu= if pre(sigma)<>0 then pre(mu) + 2*pre(pu)*pre(sigma) else pre(mu);
          pu= pre(pu);
          tcross=if pre(sigma)<>0 then sigma else pre(tcross);
          sigma= if pre(sigma)<>0 then if mu*pu <0 then -mu/pu else Modelica.Constants.inf else pre(tcross);
          sw=if pre(sigma)<>0 then 2-pre(sw) else pre(sw);
          ch=0;
        else
          u = uVal[1];
          mu= uVal[2];
          pu= uVal[3];
          tcross= if s1>0 and ((s1<s2) or (s2<0)) then s1 else if s2>0 then s2 else Modelica.Constants.inf;
          sigma= if (pre(sigma)==e and ((u>level and pre(sw)==0) or (u<level and pre(sw)==2))) then 0 else if ((u>level and pre(sw)==2) or (u<level and pre(sw)==0)) then if time>0 then 0 else tcross else tcross;
          sw=if (u>level and pre(sw)==2) or (u<level and pre(sw)==0) then 2-pre(sw) else pre(sw);
          ch=if ((u>level and pre(sw)==2) or (u<level and pre(sw)==0)) and time>0 then 1 else pre(ch);
        end if;
        lastTime=time;
       end when;

      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-22; -68,-22; -64,-22; -60,-20; -58,-18; -52,-14; -48,-8; -46,
                -2; -40,6; -38,8; -36,14; -32,22; -30,28; -26,34; -24,40; -22,46;
                -18,48; -12,48; -8,48; -6,46; -2,44; 2,42; 6,40; 12,36; 16,32; 20,
                28; 24,20; 28,18; 30,14; 34,10; 40,6; 42,4; 48,4; 50,2; 56,0; 64,0;
                70,0; 76,0], style(color=10, rgbcolor={135,135,135})),
          Line(points=[-70,18; 70,18], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-34,-50; -34,76], style(
              color=71,
              rgbcolor={85,170,255},
              pattern=3)),
          Line(points=[28,-50; 28,76], style(
              color=71,
              rgbcolor={85,170,255},
              pattern=3))),
                          Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The CrossDetect Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>level</b></td>
<td>a horizontal straight line at y=level</td>
</tr>
<tr>
<td><b>vOut</b></td>
<td>output value</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
This block detects the time instants at which the input signal crosses the level specified by the user, and produces an output with a constant value vOut.
<br/>
It may seem a bit strange that the generated output values are always the same (constant). Considering however that the CrossDetect block is aimed at detecting the time instants <b>when</b> a signal crosses the given level, the actual value of the output does not matter, but only the fact that there are output events in the appropriate moments. The interesting output variable is therefore the auxiliary variable showEvents. It is a very simple Integer variable that is incremented by 1 each time an output event is generated, the scope of which is just to have a variable with a value that changes at event instants.
<br/>
<br/>
The picture below illustrates the behaviour of a CrossDetect block that discovers the crossing instants of a given level (green) and the actual input signal, the sine signal (blue). The variable CrossDetect.uVal[1] is given in pink, but as can be easily seen it is of little use, since after the first crossing instant it just jumps from its initial value (zero) to vOut and stays there. For this reason, also the variable showEvents, the time component of the output vector, is depicted. Given the fact that this variable indicates the time instants when the sine signal crosses the level, it can be said to be the actual output of the CrossDetect block while the usual output variable (CrossDetect.uVal[1]) is rather a dummy variable, this time.
<br/>
<br/>
<center><img src=\"../Images/OutCrossDetect.png\"></center>
</html>"));
    end CrossDetect;

    block Delay "Delays an input for a certain amount of time."
      extends ModelicaDEVS.Templates.DDBlock(final method=3);
      parameter Real d= 2 "Delay value";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      Integer indexOut(start=0);
      Boolean dext;
      Boolean dint;

    function getU
      input Integer counterOut;
      output Real u_o;
    external "C";

    annotation(Include="#include <DEVSdelay.cpp>");
    end getU;

    function getMU
      input Integer counterOut;
      output Real mu_o;
    external "C";

    annotation(Include="#include <DEVSdelay.cpp>");
    end getMU;

    function getPU
      input Integer counterOut;
      output Real pu_o;
    external "C";

    annotation(Include="#include <DEVSdelay.cpp>");
    end getPU;

    function getSigmaDint
      input Integer counterOut;
      input Real tim;
      input Real delay;
      output Real sigma_o;
    external "C";

    annotation(Include="#include <DEVSdelay.cpp>");
    end getSigmaDint;

    function getSigmaDext
      input Integer counterOut;
      input Real uIN;
      input Real muIN;
      input Real puIN;
      input Real tim;
      input Real sig;
      input Real eps;
      input Real delay;
      output Real sigma_o;
    external "C";

    annotation(Include="#include <DEVSdelay.cpp>");
    end getSigmaDext;

    function getSigmaDintDext
      input Integer counterOut;
      input Real uIN;
      input Real muIN;
      input Real puIN;
      input Real tim;
      input Real sig;
      input Real eps;
      input Real delay;
      output Real sigma_o;
    external "C";

    annotation(Include="#include <DEVSdelay.cpp>");
    end getSigmaDintDext;

    equation
      dint= time >= pre(lastTime)+pre(sigma);
      dext= uEvent;
      yEvent=edge(dint);

      when {dint} then
        yVal[1]=getU(pre(indexOut));
        yVal[2]=if method>1 then getMU(pre(indexOut)) else 0;
        yVal[3]=if method>2 then getPU(pre(indexOut)) else 0;
      end when;

      when {dext, dint} then
        indexOut= if dint then if pre(indexOut)==999 then 0 else pre(indexOut)+1 else pre(indexOut);
        sigma=if dint and dext then getSigmaDintDext(indexOut, uVal[1], uVal[2], uVal[3], time, pre(sigma), time-pre(lastTime), d) else if dint then getSigmaDint(indexOut, time, d) else getSigmaDext(indexOut, uVal[1], uVal[2], uVal[3], time, pre(sigma), time-pre(lastTime), d);
        lastTime=time;
      end when;

      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,18; -46,50; -30,-26; -12,4; 10,4; 32,-74], style(
              color=71,
              rgbcolor={85,170,255},
              fillColor=71,
              rgbfillColor={85,170,255})),
          Line(points=[-38,18; -14,50; 2,-26; 20,4; 42,4; 64,-74], style(color=3, rgbcolor=
                 {0,0,255}))),                  DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Delay Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>d</b></td>
<td>delay</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Delay block takes an input signal and outputs the exact same trajectory a given amount of time later (specified by the parameter d).<br/>
<br/>
The following picture shows such an input signal (blue) and the corresponding output signal (red) with a delay of 0.1.
<br/>
<center><img src=\"../Images/OutDelay.png\"></center>
<br/>
<br/>
Contrary to the other blocks, which have been programmed in Modelica exclusively, the Delay block exploits the possibility to use externally defined functions programmed in C. The reason for this is that in order to be able to output the values of the input signal d units of time later than they have actually arrived, the Delay block has to first store the incoming event values into an array and read them out again after d units of time. Given that at implementation time, it cannot be known how many values must be stored before the first value is read out again and therefore could be overwritten by a new value, the size of the array has to be sufficiently big such that also big delays are possible. Unfortunately, it is not recommendable to declare too big an array in Modelica, since arrays are treated as a set of scalars, and too many variables in a block make its compilation and simulation become very slow. For this reason, a number of external C functions have been declared, the scope of which is to take care of the implementation parts that involve arrays. Nevertheless, the governing of the block - when to call which transition - lies still within the Modelica model itself. By means of one of the functions defined in the Delay block, it shall be illustrated what it takes to use a C function within Modelica (cf. also [Dymola]):
<ul>
<li>
Create a C++ file containing all the functions that you want to be able to use from Dymola. In the case of our Delay block the file's name is \"DEVSdelay.cpp\" and it defines several functions among which also the following one:
<br/>
<br/>
<pre>
#ifndef DEVSdelay_C
#define DEVSdelay_C
#include <math.h>
double ARRu[1000], ARRmu[1000], ARRpu[1000], ARRtime[1000];
int counterIn=1;
double getSigmaDint(int counterOut, double tim, double delay){
  if ((counterOut+1)%1000==counterIn){
    return 4e10;
  }else{
    if (ARRtime[counterOut]+delay-tim < 0){
      return counterOut;
    }else{
      return ARRtime[counterOut]+delay-tim;
    }
  }
}
[...other functions...]
#endif
</pre></pre>
<br/>
<br/>
Note that it is important to protect Dymola from including the C++ file more than once. This is done using the #ifndef and #endif construct.
<br/>
<br/>
</li>
<li>
Put the file into the folder Dymola/Source since this is where Dymola looks for the C code.
<br/>
<br/>
</li>
<li>
Now it is possible to declare a Modelica function that acts as an interface to the C function.
<br/>
As we could see in the above code snippet, the function getSigmaDint() expects three arguments and has a return value. This means we have to declare three input variables and one output value in our Modelica function. The variable declaration section of a function is usually followed by the algorithm section. In the case of an external defined function, this section is replaced by two declarations (lines 6 and 7) that tell Dymola a) that the function is an external one and b) where to find the corresponding C code.
<br/>
<br/>
<pre>
1 function getSigmaDint
2   input Integer counterOut;
3   input Real tim;
4   input Real delay;
5   output Real sigma_o;
6 external \"C\";     //instead of the \"algorithm\" declaration
7   annotation(Include=\"#include <DEVSdelay.cpp>\");
8 end getSigmaDint;
</pre>
</li>
</ul>
The function getSigmaDint() can now be used as if its whole body had been written in Modelica.
</html>"));
    end Delay;

    block Divider "Divides the first input by the second one."
      extends ModelicaDEVS.Templates.DoubleDDBlock(method=3);

      Multiplier Multiplier1 annotation (extent=[0,-10; 20,10]);
      Inverse Inverse1 annotation (extent=[-60,-50; -40,-30]);

      annotation (Icon(Text(
            extent=[-78,78; 80,-16],
            style(
              color=3,
              rgbcolor={0,0,255},
              thickness=4,
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1),
            string="_"), Text(
            extent=[-56,58; 56,-42],
            style(
              color=3,
              rgbcolor={0,0,255},
              thickness=4,
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1),
            string=":")), Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Divider Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>none</b></td>
<td></td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Divider block belongs to the binary operators and devides the first input value by the second: y=u0/u1.
<br/>
<br/>
Just like the Switch block it is not programmed explicitly, but it uses two other blocks, namely the Multiplier and the Inverse block.
</html>"));
    equation
      connect(inPort1, Multiplier1.inPort1) annotation (points=[-120,40; -20,40;
            -20,4; -2,4], style(color=3, rgbcolor={0,0,255}));
      connect(inPort2, Inverse1.inPort) annotation (points=[-120,-40; -62,-40],
          style(color=3, rgbcolor={0,0,255}));
      connect(Inverse1.outPort, Multiplier1.inPort2) annotation (points=[-38,-40;
            -20,-40; -20,-4; -2,-4], style(color=3, rgbcolor={0,0,255}));
      connect(Multiplier1.outPort, outPort)
        annotation (points=[22,0; 120,0], style(color=3, rgbcolor={0,0,255}));
    end Divider;

    block Gain "Generates an output y=g*u."
      extends ModelicaDEVS.Templates.DDBlock;
      parameter Real g= 2 "Gain value";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      Boolean dext;
      Boolean dint;

    equation
      dint= time >= pre(lastTime)+pre(sigma);
      dext= uEvent;
      yEvent=edge(dint);

      when {dint} then
        yVal[1]=uVal[1]*g;
        yVal[2]=if method>1 then uVal[2]*g else 0;
        yVal[3]=if method>2 then uVal[3]*g else 0;
      end when;

      when {dext, dint} then
        sigma=if dint then Modelica.Constants.inf else 0;
        lastTime=time;
      end when;

      annotation (Icon(Line(points=[-100,40; 98,40; 100,40], style(
              color=3,
              rgbcolor={0,0,255},
              thickness=4))),                   DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Gain Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>g</b></td>
<td>gain value</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Gain block belongs to the group of unary operator blocks. It multiplies the input signal with a given value g: y=g*u.
<br/>
<br/>
Unary operator blocks are very simple in their structure: they only take one input, apply a function and pass the result to the next block. Their internal and external transition merely consist of setting sigma to infinity or zero respectively.
<br/>
Given that these blocks only depend on external events and lack a proper internal transition (it simply consists of setting the value of sigma to infinity), their behaviour could be described by a single when-statement that would become active when dext becomes true. But this a) would not correspond to the DEVS formalism, which defines both an external and an internal transition, and b) could cause algebraic loops when connected in a cycle with a Comparator block.
</html>"));
    end Gain;

    block Hold "Samples a signal and holds the value for a period T."
      extends ModelicaDEVS.Templates.DDBlock;
      parameter Real period=1 "Sample period";
      parameter Real start=0 "Start time";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=start);
      discrete Real e; //how long has the system been in the current state yet?
      discrete Real u(start=0);
      discrete Real mu(start=0);
      discrete Real pu(start=0);
      Boolean dext;
      Boolean dint;

    equation
     dint= time >= pre(lastTime)+pre(sigma);
      dext= uEvent;
      yEvent=edge(dint);

      when {dint} then
        yVal[1]= pre(u);
        yVal[2]= if method>1 then pre(mu) else 0;
        yVal[3]= if method>2 then pre(pu) else 0;
      end when;

      when {dint, dext} then
        e=time-pre(lastTime);
        u = if dext then uVal[1] else pre(u) + pre(mu)*pre(sigma) + pre(pu)*pre(sigma)*pre(sigma); //new inputs always update u, mu, pu
        mu= if dext then uVal[2] else pre(mu); // + 2*pre(pu)*pre(sigma); ?
        pu= if dext then uVal[3] else pre(pu);
        sigma=if dint then period else pre(sigma)-e;

        lastTime=time;
      end when;

      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-22; -68,-22; -64,-22; -60,-20; -58,-18; -52,-14; -48,-8;
                -46,-2; -40,6; -38,8; -36,14; -32,22; -30,28; -26,34; -24,40; -22,
                46; -18,48; -12,48; -8,48; -6,46; -2,44; 2,42; 6,40; 12,36; 16,32;
                20,28; 24,20; 28,18; 30,14; 34,10; 40,6; 42,4; 48,4; 50,2; 56,0; 64,
                0; 70,0; 76,0],
                             style(color=10, rgbcolor={135,135,135})),
          Line(points=[-34,-50; -34,16], style(
              color=71,
              rgbcolor={85,170,255},
              pattern=3)),
          Line(points=[4,-50; 4,40], style(
              color=71,
              rgbcolor={85,170,255},
              pattern=3)),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[42,-50; 42,6], style(
              color=71,
              rgbcolor={85,170,255},
              pattern=3)),
          Line(points=[-70,-22; -34,-22; -34,18; 4,18; 4,42; 42,42; 42,4; 76,4],
              style(color=3, rgbcolor={0,0,255}))),
                          Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Hold Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>period</b></td>
<td>sample period</td>
</tr>
<tr>
<td><b>start</b></td>
<td>start time</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Hold block (called \"SampleHold\" in PowerDEVS) samples an input signal at periodical time instants which are defined by the parameters period and start: t<sub>sample</sub>=start+period*i, where i=non-negative numbers. It holds the sampled value until the next sampling instant.
<br/>
<br/>
The picture below shows a sine signal (blue) that is sampled (red) at a frequency of T=0.25.
<br/>
<br/>
<center><img src=\"../Images/OutHold.png\"></center>
</html>"));
    end Hold;

    block Hysteresis "Simple hysteretic function (2-value-mapping)."
      extends ModelicaDEVS.Templates.DDBlock(final method=3);
      parameter Real xU=1;
      parameter Real xL=-1; //andere Bezeichnungen..
      parameter Real yU=1;
      parameter Real yL=-1;

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=0);
      discrete Real u(start=0);
      discrete Real mu(start=0);
      discrete Real pu(start=0);
      discrete Real level(start=1);
      discrete Real c;
      discrete Real s1;
      discrete Real s2;
      Boolean dint;
      Boolean dext;

    equation
     dint= time >= pre(lastTime)+pre(sigma);
      dext= uEvent;
      yEvent=edge(dint);

      when {dint} then
        yVal[1]=if pre(level)==0 then yU else yL;
        yVal[2]=0; //always zero
        yVal[3]=0; //always zero
      end when;

      when {dint,dext} then
        //prepare variables s1 and s2 to compute sigma
        c= if level==0 then u-xU else u-xL;
        if pu==0 then
          if mu==0 then
            s1=Modelica.Constants.inf;
            s2=Modelica.Constants.inf;
          else
            s1=-c/mu;
            s2=Modelica.Constants.inf;
          end if;
        else
          if mu*mu-4*pu*c > 0 then
            s1=(-mu+sqrt(mu*mu-4*pu*c))/2/pu;
            s2=(-mu-sqrt(mu*mu-4*pu*c))/2/pu;
          else
            s1=Modelica.Constants.inf;
            s2=Modelica.Constants.inf;
          end if;
        end if;

        u = if dext then uVal[1] else pre(u) + pre(mu)*pre(sigma) + pre(pu)*pre(sigma)*pre(sigma);
        mu= if dext then uVal[2] else pre(mu) + 2*pre(pu)*pre(sigma);
        pu= if dext then uVal[3] else pre(pu);
        level= if dint then 1-pre(level) else pre(level);
        sigma= if (u>xU and level==0) or (u<xL and level==1) then 0 else if s1>0 and ((s1<s2) or (s2<0)) then s1 else if s2>0 then s2 else Modelica.Constants.inf;
        lastTime=time;
      end when;

      annotation (Icon(
          Line(points=[-100,-64; 50,-64; 50,62], style(color=3, rgbcolor={0,0,255})),
          Line(points=[100,62; -46,62; -46,-64], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Polygon(points=[-60,12; -34,12; -46,-10; -60,12], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1)),
          Polygon(points=[38,-10; 64,-10; 50,12; 38,-10], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1))),                 DymolaStoredErrors,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Hysteresis Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>xU</b></td>
<td>upper hysteresis window bound</td>
</tr>
<tr>
<td><b>xL</b></td>
<td>lower hysteresis window bound</td>
</tr>
<tr>
<td><b>yU</b></td>
<td>upper output value (upper quantum bound)</td>
</tr>
<tr>
<td><b>yL</b></td>
<td>lower output value (lower quantum bound)</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Hysteresis block is a very simple hysteretic quantisation function that maps the trajectory of the input function to only two values (yL and yU). However, the resulting quantisation function is hysteretic: when the input function crosses the value xU from below, the block produces an output of the value yU. Analogously, when the signal crosses xL from above, the Hysteresis block produces an output with the value yL. If the signal crosses either xU from above or xL from below, nothing happens. This means in particular that the input function can take the same value twice, each time though triggering a different output event.
<br/>
See also the <a href=\"Modelica://ModelicaDEVS.UsersGuide.QSS\"> Quantised State Systems</a> section for more details about hysteretic quantisation functions.
<br/>
<br/>
The following picture shows an input function in the form of a sine signal (blue) and the output of the Hysteresis block (red) with the following parameter setting: xU =1.5, xL =-1, yU =0.5 and yL =-0.5.
<br/>
<br/>
<center><img src=\"../Images/OutHysteresis.png\"></center>
</html>"));

    end Hysteresis;

    block Integrator
      "Integration of the input function (Integrator wrapper block)."
      extends ModelicaDEVS.Templates.DDBlockSpecial;
      parameter Real quantum= 0.1 "Quantum";
      parameter Real startX=0 "Start Value of x";

    protected
      IntegratorQSS1 IntegratorQSS1_1(quantum=quantum,startX=startX) if method == 1
        annotation (extent=[-60,40; -40,60]);
      IntegratorQSS2 IntegratorQSS2_1(quantum=quantum,startX=startX) if method == 2
        annotation (extent=[-10,-10; 10,10]);
      IntegratorQSS3 IntegratorQSS3_1(quantum=quantum,startX=startX) if method == 3
        annotation (extent=[20,-60; 40,-40]);
      annotation (Diagram, Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-50; 2,78], style(color=3, rgbcolor={0,0,255})),
          Polygon(points=[-70,-50; -42,0; -42,-50; -70,-50],  style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Text(
            extent=[-74,40; 60,-76],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1),
            string="1"),
          Text(
            extent=[-40,40; 94,-76],
            style(
              color=6,
              rgbcolor={255,255,0},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1),
            string="2"),
          Text(
            extent=[6,40; 140,-76],
            string="3",
            style(
              color=1,
              rgbcolor={255,0,0},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1))),
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Integrator-Wrapper Block</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>quantum</b></td>
<td>output quantisation degree</td>
</tr>
<tr>
<td><b>startX</b></td>
<td>initial start value (initial condition)</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
Actually, the library contains three different Integrator blocks -- one for each type of QSS. The reason for not having merged them into a single block is that they heavily differ from each other, so putting them together would have led to a block the code of which would have become very complex and thus uncomfortable to read.
<br/>
However, in order to still be able to exploit the functionality of the WorldModel block (switching between different types of QSS), there is an \"integrator-wrapper\" component that features the same ports and parameters as an Integrator does, but has an additional parameter to choose between the QSS1, QSS2 or QSS3 Integrator. The internal structure of the model looks as follows: all three types of Integrator blocks are present, and each of them has its port connected to the corresponding port of the wrapper component. Their instantiation however depends on the value of the method parameter (i.e. world.qss). See the code snippet below for an illustration:
<pre>
1 block Integrator
2   extends ModelicaDEVS.Interfaces.DDBlockIntegratorMulti;
3   parameter Real quantum= 0.1 \"Quantum\";
4   parameter Real startX=0 \"Start Value of x\";
5
6   IntegratorQSS1 IntegratorQSS1_1(quantum=quantum,startX=startX) if method == 1;
7   IntegratorQSS2 IntegratorQSS2_1(quantum=quantum,startX=startX) if method == 2;
8   IntegratorQSS3 IntegratorQSS3_1(quantum=quantum,startX=startX) if method == 3;
</pre>
If method takes a value of 1, only the QSS1 Integrator is instantiated (line 6), if method equals 2, only the QSS2 Integrator is instantiated (line 7), and the same holds for a method value of 3 (line 8). It is implied that connections leading to a block are only instantiated if the block itself has been instantiated.
<br/>
As stated before, the integrator wrapper block has the same parameters (quantum and startX) as a real Integrator (lines 3 and 4). This circumstance allows the wrapper to initialise the instantiated Integrator block with the appropriate parameter values. It is not very illustrative an example, given that the parameters of a specific Integrator and the integrator wrapper block have the same names, and thus the parameter initialisation unfortunately results in an instruction like quantum=quantum and startX=startX. Nevertheless, it should be understandable how parameter propagation within a model works.
</html>"));

    equation
      connect(inPort, IntegratorQSS1_1.inPort)
        annotation (points=[-120,0; -70,0; -70,50; -62,50],
                                            style(color=3, rgbcolor={0,0,255}));
      connect(inPort, IntegratorQSS2_1.inPort)
        annotation (points=[-120,0; -12,0], style(color=3, rgbcolor={0,0,255}));
      connect(inPort, IntegratorQSS3_1.inPort) annotation (points=[-120,0; -70,0;
            -70,-50; 18,-50],   style(color=3, rgbcolor={0,0,255}));
      connect(IntegratorQSS2_1.outPort, outPort)
        annotation (points=[12,0; 120,0], style(color=3, rgbcolor={0,0,255}));
      connect(IntegratorQSS3_1.outPort, outPort) annotation (points=[42,-50; 56,-50;
            56,0; 120,0],      style(color=3, rgbcolor={0,0,255}));
      connect(IntegratorQSS1_1.outPort, outPort) annotation (points=[-38,50; 56,50;
            56,0; 120,0], style(color=3, rgbcolor={0,0,255}));
      connect(IntegratorQSS1_1.outPortInterpolator, outPortInterpolator)
        annotation (points=[-50,38; -50,-80; 0,-80; 0,-120], style(color=1,
            rgbcolor={255,0,0}));
      connect(IntegratorQSS3_1.outPortInterpolator, outPortInterpolator)
        annotation (points=[30,-62; 30,-80; 0,-80; 0,-120], style(color=1, rgbcolor=
             {255,0,0}));
      connect(IntegratorQSS2_1.outPortInterpolator, outPortInterpolator)
        annotation (points=[0,-12; 0,-120], style(color=1, rgbcolor={255,0,0}));

    end Integrator;

    block IntegratorQSS1 "Integration of the input function."
      extends ModelicaDEVS.Templates.DDBlockSpecial(final method=1);
      parameter Real quantum= 0.1 "Quantum";
      parameter Real startX=0 "Start Value of x";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=0);
      discrete Real X(start=startX); //integration value (accumulated)
      discrete Real q(start=startX); //quantized variable
      Boolean dint;
      Boolean dext;

    equation
      dint = time >= pre(lastTime)+pre(sigma);
      dext = uEvent;
      yEvent= edge(dint);
      yIntEvent= edge(dint) or edge(dext);

      when dint then
        yVal[1]= pre(q) + quantum*sign(pre(uVal[1]));
        yVal[2]= 0;
        yVal[3]= 0;
        q=X;
      end when;

      when {dint, dext} then
        if dint then
          X= pre(X)+pre(sigma)*pre(uVal[1]);
          sigma= if abs(uVal[1])<= Modelica.Constants.small then Modelica.Constants.inf else quantum/abs(uVal[1]);
        else
          X= pre(X) + (time-pre(lastTime))*pre(uVal[1]); //pre(uVal[1]) isn't against an algebraic loop but because we have to use the old value of u.
          sigma=if pre(sigma)==0 then 0 else if abs(uVal[1])<= Modelica.Constants.small then Modelica.Constants.inf else (pre(q)+quantum*sign(uVal[1])-X)/uVal[1];
        end if;
        yIntVal[1]= X;       //coefficient of the constant term of the Taylor series (x)
        yIntVal[2]= uVal[1]; //coefficient of the linear term of the Taylor series (x'); uVal[1]=x'
        yIntVal[3]= 0;
        yIntVal[4]= 0;
        lastTime= time;
      end when;

    initial equation
      yVal[1]=startX;
      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-50; 2,78], style(color=3, rgbcolor={0,0,255})),
          Polygon(points=[-70,-50; -70,-50], style(color=3, rgbcolor={0,0,255})),
          Polygon(points=[-70,-50; -28,24; -28,-50; -70,-50], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255})),
          Text(
            extent=[-8,40; 126,-76],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1),
            string="1")), Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Integrator Block (QSS1 Mode)</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>quantum</b></td>
<td>output quantisation degree</td>
</tr>
<tr>
<td><b>startX</b></td>
<td>initial start value (initial condition)</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Integrator is, so to speak, the core component of ModelicaDEVS. Its purpose is to integrate a (piecewise constant) function originating from another DEVS block that is connected to the Integrator's input port.
<br/>
<br/>
The picture illustrating the behaviour of the Integrator shows a sine signal (blue) and the integrated sine function (red).
<br/>
<br/>
<center><img src=\"../Images/OutIntegrator.png\"></center>
</html>"));
    equation

    end IntegratorQSS1;

    block IntegratorQSS2 "Integration of the input function."
      extends ModelicaDEVS.Templates.DDBlockSpecial(final method=2);
      parameter Real quantum= 0.1 "Quantum";
      parameter Real startX=0 "Start Value of x";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=0);
      discrete Real e(start=0); //how long has the system been in the current state yet?
      discrete Real X(start=startX); //integration value (accumulated)
      discrete Real q(start=startX); //quantized variable
      discrete Real mq(start=0); //slope of q
      discrete Real u(start=0); //holder variable for input coming in in dext
      discrete Real mu(start=0); //slope of u
      Boolean dint;
      Boolean dext;

    function getSigma
      input Real quantum_i;
      input Real sigma_i;
      input Real q_i;
      input Real mq_i;
      input Real u_i;
      input Real mu_i;
      input Real X_i;
      input Real e_i;
      output Real sigma_o;
      protected
      Real a;
      Real b;
      Real c;
      Real s;
      Real q_p;
      Real sigma_p;

    algorithm
      q_p:=q_i;
      if (sigma_i<>0) then
        a:=mu_i/2;
        b:=u_i - mq_i;
        c:=X_i - q_p + quantum_i;
        sigma_p:=Modelica.Constants.inf;
        if (a==0) then
          if (b<>0) then
             s:=-c/b;
             if (s>0) then
               sigma_p:=s;
             end if;
             c:=X_i - q_p - quantum_i;
             s:=-c/b;
             if s>0 and s<sigma_p then
               sigma_p:=s;
             end if;
          end if;
        else
          if b*b-4*a*c > 0 then
            s:=(-b + sqrt(b*b - 4*a*c))/2/a;
            if (s>0) then
              sigma_p:=s;
            end if;
            s:=(-b - sqrt(b*b - 4*a*c))/2/a;
            if s>0 and s<sigma_p then
              sigma_p:=s;
            end if;
          end if;
          c:= X_i - q_p - quantum_i;
          if b*b-4*a*c > 0 then
            s:=(-b + sqrt(b*b - 4*a*c))/2/a;
            if s>0 and s<sigma_p then
              sigma_p:=s;
            end if;
            s:=(-b - sqrt(b*b - 4*a*c))/2/a;
            if s>0 and s<sigma_p then
              sigma_p:=s;
            end if;
          end if;
        end if;
        if (X_i-q_p)>quantum_i or (q_p-X_i)>quantum_i then
          sigma_p:=0;
        end if;
      end if;
      sigma_o:=sigma_p;
    end getSigma;

    equation
      dint = time >= pre(lastTime)+pre(sigma);
      dext = uEvent;
      yEvent= edge(dint);
      yIntEvent= edge(dint) or edge(dext);

      when dint then
        yVal[1]= pre(X) + pre(u)*pre(sigma) + pre(mu)*pre(sigma)*pre(sigma)/2;
        yVal[2]= pre(u) + pre(mu)*pre(sigma);
        yVal[3]=0;
      end when;

      when {dint, dext} then
        e=time-pre(lastTime);
        if dint then
          X= pre(X) + pre(u)*pre(sigma) + pre(mu)*pre(sigma)*pre(sigma)/2;
          sigma= if pre(mu)==0 then Modelica.Constants.inf else sqrt(2*quantum/abs(mu));
          u=pre(u)+mu*pre(sigma);
          mu=pre(mu);
          q=X;
          mq=u;
        else
          X= pre(X) + pre(u)*e + pre(mu)*e*e/2;
          u=uVal[1];
          mu=uVal[2];
          q=if pre(sigma)<>0 then pre(q)+pre(mq)*e else pre(q);
          mq=pre(mq);
          sigma=getSigma(quantum, pre(sigma), q, mq, u, mu, X, e);
        end if;
        yIntVal[1]= X;    // coefficient of the constant term of the Taylor series (x)
        yIntVal[2]= u;    // coefficient of the linear term of the Taylor series (x'); uVal[1]= x'
        yIntVal[3]= mu/2; // coefficient of the quadratic term of the Taylor series (x''/2); uVal[2] = x''
        yIntVal[4]= 0;
        lastTime= time;
      end when;

    initial equation
      yVal[1]=startX;
      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-50; 2,78], style(color=3, rgbcolor={0,0,255})),
          Polygon(points=[-70,-50; -70,-50], style(color=3, rgbcolor={0,0,255})),
          Polygon(points=[-70,-50; -28,24; -28,-50; -70,-50], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255})),
          Text(
            extent=[-8,40; 126,-76],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1),
            string="2")), Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Integrator Block (QSS2 Mode)</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>quantum</b></td>
<td>output quantisation degree</td>
</tr>
<tr>
<td><b>startX</b></td>
<td>initial start value (initial condition)</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Integrator is, so to speak, the core component of ModelicaDEVS. Its purpose is to integrate a (piecewise constant) function originating from another DEVS block that is connected to the Integrator's input port.
<br/>
<br/>
The picture illustrating the behaviour of the Integrator shows a sine signal (blue), the integrated sine function (red) and its first derivative (green).
<br/>
<br/>
<center><img src=\"../Images/OutIntegratorQSS2.png\"></center>
</html>"));
    equation

    end IntegratorQSS2;

    block IntegratorQSS3 "Integration of the input function."
      extends ModelicaDEVS.Templates.DDBlockSpecial(final method=3);
      parameter Real quantum= 0.1 "Quantum";
      parameter Real startX=0 "Start Value of x";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=0);
      discrete Real e(start=0); //how long has the system been in the current state yet?
      discrete Real X(start=startX); //integration value (accumulated)
      discrete Real q(start=startX); //quantized variable
      discrete Real mq(start=0); //slope of q
      discrete Real pq(start=0); //slope of mq
      discrete Real u(start=0); //holder variable for input coming in in dext
      discrete Real mu(start=0); //slope of u
      discrete Real pu(start=0); //slope of mu
      Boolean dint;
      Boolean dext;

    function getSigma
      input Real quantum_i;
      input Real sigma_i;
      input Real q_i;
      input Real mq_i;
      input Real pq_i;
      input Real u_i;
      input Real mu_i;
      input Real pu_i;
      input Real X_i;
      input Real e_i;
      output Real sigma_o;
      protected
      Real a;
      Real b;
      Real c;
      Real s;
      Real v;
      Real w;
      Real A;
      Real B;
      Real i1;
      Real i2;
      Real x1;
      Real x2;
      Real y1;
      Real y2;
      Real y3;
      Real arg;
      Real pidiv3;
      Real sigma_p;

    algorithm
      pidiv3:= Modelica.Constants.pi/3;
      a:=mu_i/2 - pq_i;
      b:=u_i - mq_i;
      c:=X_i - q_i - quantum_i;
      sigma_p:=sigma_i;
      if pu_i<>0 then
        a:=3*a/pu_i;
        b:=3*b/pu_i;
        c:=3*c/pu_i;
        v:=b - a*a/3;
        w:=c - b*a/3 + 2*a*a*a/27;
        i1:=-w/2;
        i2:=i1*i1 + v*v*v/27;

        if i2>0 then //first "if i2>0 then"
          i2:=sqrt(i2);
          A:=i1 + i2;
          B:=i1 - i2;
          if A>0 then
            A:=A^(1.0/3);
          else
            A:=-(abs(A)^(1.0/3));
          end if;
          if B>0 then
            B:=B^(1.0/3);
          else
            B:=-(abs(B)^(1.0/3));
          end if;
          s:=A + B - a/3;

          if s<0 then
            s:=Modelica.Constants.inf;
          end if;
        else
          if (i2==0) then
            A:=i1;
            if A>0 then
              A:=A^(1.0/3);
            else
              A:=-(abs(A)^(1.0/3));
            end if;
            x1:=2*A - a/3;
            x2:=-(A + a/3);
            if x1<0 then
              if x2<0 then
                s:=Modelica.Constants.inf;
              else
                s:=x2;
              end if;
            else
              if x2<0 then
                s:=x1;
              else
                s:=min(x1,x2);
              end if;
            end if;
          else //belongs to first " if i2>0 then"
            if v<0 then
              arg:=w*sqrt(27/(-v))/(2*v);
              arg:=Modelica.Math.acos(arg)/3;
              y1:=2*sqrt(-v/3);
            else
              arg:=Modelica.Constants.inf;
              y1:=Modelica.Constants.inf;
            end if;
            y2:=-y1*cos(pidiv3 - arg) - a/3;
            y3:=-y1*cos(pidiv3 + arg) - a/3;
            y1:=y1*cos(arg) - a/3;
            if y1<0 then
              s:=Modelica.Constants.inf;
            else
              if y3<0 then
                s:=y1;
              else
                if y2<0 then
                  s:=y3;
                else
                  s:=y2;
                end if;
              end if;
            end if;
          end if; //belongs to if in else branch of first " if i2>0 then"
        end if; //first "if i2>0 then" finished
        c:=c + 6*quantum_i/pu_i;
        w:=c - b*a/3 + 2*a*a*a/27;
        i1:=-w/2;
        i2:=i1*i1 + v*v*v/27;

        if i2>0 then //second "if i2>0 then"
          i2:=sqrt(i2);
          A:=i1 + i2;
          B:=i1 - i2;
          if A>0 then
            A:=A^(1.0/3);
          else
            A:=-(abs(A)^(1.0/3));
          end if;
          if B>0 then
            B:=B^(1.0/3);
          else
            B:=-(abs(B)^(1.0/3));
          end if;
          sigma_p:=A + B - a/3;
          if s<sigma_p or sigma_p<0 then
            sigma_p:=s;
          end if;

        else //belongs to second "if i2>0 then"
          if i2==0 then
            A:=i1;
            if A>0 then
              A:=A^(1.0/3);
            else
              A:=-(abs(A)^(1.0/3));
            end if;
            x1:=2*A - a/3;
            x2:=-(A + a/3);
            if x1<0 then
              if x2<0 then
                sigma_p:=Modelica.Constants.inf;
              else
                sigma_p:=x2;
              end if;
            else
              if x2<0 then
                sigma_p:=x1;
              else
                sigma_p:=min(x1,x2);
              end if;
            end if;
            if s<sigma_p then
              sigma_p:=s;
            end if;

          else //belongs actually to second "if i2>0 then"
            if v<0 then
              arg:=w*sqrt(27/(-v))/(2*v);
              arg:=Modelica.Math.acos(arg)/3;
              y1:=2*sqrt(-v/3);
            else
              arg:=Modelica.Constants.inf;
              y1:=Modelica.Constants.inf;
            end if;

            y2:=-y1*cos(pidiv3 - arg) - a/3;
            y3:=-y1*cos(pidiv3 + arg) - a/3;
            y1:=y1*cos(arg) - a/3;

            if y1<0 then
              sigma_p:=Modelica.Constants.inf;
            else
              if y3<0 then
                sigma_p:=y1;
              else
                if y2<0 then
                  sigma_p:=y3;
                else
                  sigma_p:=y2;
                end if;
              end if;
            end if;
            if s<sigma_p then
              sigma_p:=s;
            end if;
          end if;
        end if;//second "if i2>0 then" finished

      else //belongs to "if pu<>0 then"
        if a<>0 then
          x1:=b*b - 4*a*c;
          if (x1<0) then
            s:=Modelica.Constants.inf;
          else
            if x1==0 then
              x1:=0;
            else
              x1:=sqrt(x1);
            end if;
            x2:=(-b - x1)/2/a;
            x1:=(-b + x1)/2/a;
            if x1<0 then //first "if x1<0 then"
              if x2<0 then
                s:=Modelica.Constants.inf;
              else
                s:=x2;
              end if;
            else
              if x2<0 then
                 s:=x1;
              else
                if x1<x2 then
                  s:=x1;
                else
                  s:=x2;
                end if;
              end if;
            end if;
          end if; //belongs to first "if x1<0 then"
          c:=c + 2*quantum_i;
          x1:=b*b - 4*a*c;
          if x1<0 then //second "if x1<0 then"
            sigma_p:=Modelica.Constants.inf;
          else
            if x1==0 then
              x1:=0;
            else
              x1:=sqrt(x1);
            end if;
            x2:=(-b - x1)/2/a;
            x1:=(-b + x1)/2/a;
            if x1<0 then
              if x2<0 then
                sigma_p:=Modelica.Constants.inf;
              else
                sigma_p:=x2;
              end if;
            else
              if x2<0 then
                sigma_p:=x1;
              else
                sigma_p:=min(x1,x2);
              end if;
            end if;
          end if; //belongs to second "if x1<0 then"
          if s<sigma_p then
            sigma_p:=s;
          end if;

         else //gehört zu a<>0
           if b<>0 then
             x1:=-c/b;
             x2:=x1 - 2*quantum_i/b;
             if x1<0 then
               x1:=Modelica.Constants.inf;
             end if;
             if x2<0 then
               x2:=Modelica.Constants.inf;
             end if;
             sigma_p:=min(x1, x2);
           end if;
         end if; //"if a<>0 then" finished
       end if; //"if pu<>0 then" finished
       if ((abs(X_i-q_i))>quantum_i) then
         sigma_p:=0;
       end if;
       sigma_o:=sigma_p;
    end getSigma;

    equation
      dint = time >= pre(lastTime)+pre(sigma);
      dext = uEvent;
      yEvent= edge(dint);
      yIntEvent= edge(dint) or edge(dext);

      when dint then
        yVal[1]= pre(X) + pre(u)*pre(sigma) + pre(mu)*(pre(sigma)^2)/2 + pre(pu)*(pre(sigma)^3)/3;
        yVal[2]= pre(u) + pre(mu)*pre(sigma) + pre(pu)*(pre(sigma)^2);
        yVal[3]= pre(mu)/2.0 + pre(pu)*pre(sigma);
      end when;

      when {dint, dext} then
        e=time-pre(lastTime);

        if dint then
          X= pre(X) + pre(u)*pre(sigma) + pre(mu)*(pre(sigma)^2)/2 + pre(pu)*(pre(sigma)^3)/3;
          u=pre(u) + pre(mu)*pre(sigma) + pu*pre(sigma)*pre(sigma);
          mu=pre(mu)+2*pu*pre(sigma);
          pu=pre(pu);
          q=X;
          mq=u;
          pq= mu/2;
          sigma= if pu==0 then Modelica.Constants.inf else abs(3*quantum/pu)^(1.0/3);
        else
          X= pre(X) + pre(u)*e + pre(mu)*e*e/2 + pre(pu)*e*e*e/3;
          u=uVal[1];
          mu=uVal[2];
          pu=uVal[3];
          q= if pre(sigma)<>0 then pre(q)+pre(mq)*e+pq*e*e else pre(q);
          mq=if pre(sigma)<>0 then pre(mq)+2*pq*e else pre(mq);
          pq=pre(pq);
          sigma=if pre(sigma)<>0 then getSigma(quantum, pre(sigma), q, mq, pq, u, mu, pu, X, e) else pre(sigma);
        end if;
        yIntVal[1]=X;    // coefficient of the constant term of the Taylor series (x)
        yIntVal[2]=u;    // coefficient of the linear term of the Taylor series (x'); uVal[1] = x'
        yIntVal[3]=mu/2; // coefficient of the quadratic term of the Taylor series (x''/2); uVal[2] = x''
        yIntVal[4]=pu/3; // coefficient of the cubic term of the Taylor series (x'''/6); uVal[3] = x'''/2
        lastTime= time;
      end when;

    initial equation
      yVal[1]=startX;
      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-50; 2,78], style(color=3, rgbcolor={0,0,255})),
          Polygon(points=[-70,-50; -70,-50], style(color=3, rgbcolor={0,0,255})),
          Polygon(points=[-70,-50; -28,24; -28,-50; -70,-50], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255})),
          Text(
            extent=[-8,40; 126,-76],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255},
              fillPattern=1),
            string="3")), Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Integrator Block (QSS3 Mode)</b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>quantum</b></td>
<td>output quantisation degree</td>
</tr>
<tr>
<td><b>startX</b></td>
<td>initial start value (initial condition)</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Integrator is, so to speak, the core component of ModelicaDEVS. Its purpose is to integrate a (piecewise constant) function originating from another DEVS block that is connected to the Integrator's input port.
<br/>
<br/>
The picture illustrating the behaviour of the Integrator shows a sine signal (blue), the integrated sine function (red), its first derivative (green) and its second derivative devided by 2 (pink).
<br/>
<br/>
<center><img src=\"../Images/OutIntegratorQSS3.png\"></center>
</html>"));
    equation

    end IntegratorQSS3;

    block Inverse "Inverts a value u: y=1/u."
      extends ModelicaDEVS.Templates.DDBlock;

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      Boolean dext;
      Boolean dint;

    equation
      dint= time >= pre(lastTime)+pre(sigma);
      dext= uEvent;
      yEvent=edge(dint);

      when dint then
        yVal[1]=if uVal[1]<= Modelica.Constants.small then Modelica.Constants.inf else 1/uVal[1];
        yVal[2]=if uVal[1]<= Modelica.Constants.small then Modelica.Constants.inf else -uVal[2]/(uVal[1]^2);
        yVal[3]=if method<>3 then 0 else if uVal[1] <= Modelica.Constants.small then Modelica.Constants.inf else -uVal[3]/(uVal[1]^2)+uVal[2]/(uVal[1]^3);
      end when;

      when {dext, dint} then
        sigma=if dint then Modelica.Constants.inf else 0;
        lastTime=time;
      end when;

      annotation (Icon(Text(
            extent=[-84,58; 58,-46],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillPattern=1),
            string="()"),
                       Text(
            extent=[10,80; 64,10],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillPattern=1),
            string="-1"),
                       Text(
            extent=[-82,76; 60,-28],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillPattern=1),
            string=".")), Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Inverse Block </b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>none</b></td>
<td></td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Inverse block belongs to the group of unary operator blocks. It calculates the inverse value of an input value: y=u^(-1).
<br/>
<br/>
Unary operator blocks are very simple in their structure: they only take one input, apply a function and pass the result to the next block. Their internal and external transition merely consist of setting sigma to infinity or zero respectively.
<br/>
Given that these blocks only depend on external events and lack a proper internal transition (it simply consists of setting the value of sigma to infinity), their behaviour could be described by a single when-statement that would become active when dext becomes true. But this a) would not correspond to the DEVS formalism, which defines both an external and an internal transition, and b) could cause algebraic loops when connected in a cycle with a Comparator block.
</html>"));
    end Inverse;

    block Multiplier "Multiplies two values."
      extends ModelicaDEVS.Templates.DoubleDDBlock;

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      discrete Real e; //how long has the system been in this state yet?
      discrete Real newVal11;
      discrete Real newVal12;
      discrete Real newVal13;
      discrete Real newVal21;
      discrete Real newVal22;
      discrete Real newVal23;
      Boolean dext1;
      Boolean dext2;
      Boolean dint;

    equation
      dext1= uEvent1;
      dext2= uEvent2;
      dint = time >= pre(lastTime)+pre(sigma);
      yEvent= edge(dint);

      when dint then
        yVal[1]= pre(newVal11)*pre(newVal21);
        yVal[2]= if method>1 then pre(newVal12)*pre(newVal21) + pre(newVal22)*pre(newVal11) else 0;
        yVal[3]= if method>2 then pre(newVal11)*pre(newVal23) + pre(newVal12)*pre(newVal22) + pre(newVal13)*pre(newVal21) else 0;
      end when;

      when {dint, dext1, dext2} then
        e=time-pre(lastTime);
        newVal11= if dint then pre(newVal11) else if dext1 then uVal1[1] else pre(newVal11)+pre(newVal12)*e+pre(newVal13)*e*e;
        newVal12= if dint then pre(newVal12) else if dext1 then uVal1[2] else pre(newVal12)+2*pre(newVal13)*e;
        newVal13= if dint then pre(newVal13) else if dext1 then uVal1[3] else pre(newVal13);
        newVal21= if dint then pre(newVal21) else if dext2 then uVal2[1] else pre(newVal21)+pre(newVal22)*e+pre(newVal23)*e*e;
        newVal22= if dint then pre(newVal22) else if dext2 then uVal2[2] else pre(newVal22)+2*pre(newVal23)*e;
        newVal23= if dint then pre(newVal23) else if dext2 then uVal2[3] else pre(newVal23);
        sigma= if dint then Modelica.Constants.inf else 0;
        lastTime=time;
      end when;

    initial equation
      // initial equations needed because yVal[1] depends on pre()
      newVal11=uVal1[1];
      newVal12=uVal1[2];
      newVal13=uVal1[3];
      newVal21=uVal2[1];
      newVal22=uVal2[2];
      newVal23=uVal2[3];

      annotation (Icon(Text(
            extent=[-74,46; 80,-92],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillPattern=1),
            string="*")), Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Multiplier Block </b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>none</b></td>
<td></td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Multiplier block belongs to the group of binary operator blocks. It multiplies two input values:y=u0*u1.
<br/>
<br/>
The mechanism of a binary operator block is divided into two parts: a first part that becomes active at the occurrence of an internal event, and a second part that is activated by an internal as well as an external event:
<ul>
<li>
The first when-statement can be simply thought of as the analogon to the lambda output function.
</li>
<li>
The second when-statement represents the external and the internal transition. It shows one of the typical properties of the binary operator blocks: usually, only one of the two input ports receives a new signal whereas the other one remains silent, i.e. still holds the value that it had adopted the last time it received a signal. The evaluation of the output of the Add block could now simply depend on the old value of the inactive port and the new value that has arrived through the active one. However, in order to make the computation as accurate as possible, the old value of the silent port is replaced with an estimation of a value that the signal coming in through the silent port is likely to have adopted in the meantime (since the last time when there was an explicit external event). The estimation is carried out on the basis of the signal's previous Taylor series values (the coefficients to the constant, linear and quadratic terms).
<br/>
The following figure shows an example of possible inputs and outputs at the ports of an <b>Add</b> block. For the input signals, the current value as well as the coefficient of the first derivative (which is equal to the linear term of the Taylor series expansion) of the input function are graphically indicated. The output graph labelled \"output\" gives the true output involving the estimated value for silent ports. The graph labelled \"alternative output\" shows what the output would look like if no estimation for the function coming in through the silent port took place (which is the case in QSS1 where no higher-order Taylor series expansion is used).
<br/>
<br/>
<center><img src=\"../Images/AddWork.png\" width=\"400\"></center>
</li>
</ul>
</html>"));
    end Multiplier;

    block Power "Generates an output y=u^n."
      extends ModelicaDEVS.Templates.DDBlock;
      parameter Real n= 2 "Exponent value";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      Boolean dext;
      Boolean dint;

    equation
      dint= time >= pre(lastTime)+pre(sigma);
      dext= uEvent;
      yEvent=edge(dint);

      when {dint} then
        yVal[1]=if n==0 then 0 else if n==1 then uVal[1] else uVal[1]^n;
        yVal[2]=if n==0 then 0 else if n==1 then uVal[2] else n*(uVal[1]^(n-1))*uVal[2];
        yVal[3]=if method <> 3 then 0 else if n==0 then 0 else if n==1 then uVal[3] else if n==2 then  yVal[2]*yVal[2] + n*yVal[1]*yVal[2] else n*(n-1)*(yVal[1]^(n-2))*yVal[2]*yVal[2]/2 + n*(yVal[1]^(n-1))*yVal[2];
      end when;

      when {dext, dint} then
        sigma=if dint then Modelica.Constants.inf else 0;
        lastTime=time;
      end when;

      annotation (Icon(Text(
            extent=[-76,40; 78,-98],
            style(
              color=3,
              rgbcolor={0,0,255},
              fillPattern=1),
            string="^")),                       DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Power Block </b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>n</b></td>
<td>exponent value</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Power block belongs to the group of unary operator blocks. It puts the input signal into the power of n: y=u^n.
<br/>
<br/>
Unary operator blocks are very simple in their structure: they only take one input, apply a function and pass the result to the next block. Their internal and external transition merely consist of setting sigma to infinity or zero respectively.
<br/>
Given that these blocks only depend on external events and lack a proper internal transition (it simply consists of setting the value of sigma to infinity), their behaviour could be described by a single when-statement that would become active when dext becomes true. But this a) would not correspond to the DEVS formalism, which defines both an external and an internal transition, and b) could cause algebraic loops when connected in a cycle with a Comparator block.
</html>"));
    end Power;

    block Quantiser "Quantisation of the input function."
      extends ModelicaDEVS.Templates.DDBlock;
      parameter Real quantum= 0.1 "Quantum";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      discrete Real xl(start=0);
      discrete Real xu(start=0);
      discrete Real u(start=0);
      discrete Real mu(start=0);
      discrete Real pu(start=0);
      Boolean dint;
      Boolean dext;

    /*************************************************************/
    /**********************   FUNCTIONS   ************************/
    /*************************************************************/
      function getSigmaDext
        input Real u_i;
        input Real mu_i;
        input Real pu_i;
        input Real xl_i;
        input Real xu_i;
        output Real sigma_o;
      protected
        Real s[2];
        Real sol[2];
        Real c;

      algorithm
        s[1]:=Modelica.Constants.inf;
        s[2]:=Modelica.Constants.inf;
        sol[1]:=Modelica.Constants.inf;
        sol[2]:=Modelica.Constants.inf;

        for i in 1:2 loop
          if (i==1) then
            c:=u_i - xl_i;
          else
            c:=u_i - xu_i;
          end if;

          if pu_i == 0 then
            if mu_i<>0 then
              s[1]:=-c/mu_i;
            end if;
          else
            if mu_i*mu_i >= 4*pu_i*c then
              s[1]:=(-mu_i + sqrt(mu_i*mu_i - 4*pu_i*c))/(2*pu_i);
              s[2]:=(-mu_i - sqrt(mu_i*mu_i - 4*pu_i*c))/(2*pu_i);

              if s[1] <=0 then
                s[1]:=Modelica.Constants.inf;
              end if;
              if s[2] <=0 then
                s[2]:=Modelica.Constants.inf;
              end if;
            end if;
          end if;

          if u_i ==xl_i and ((mu_i<=0 and pu_i<0) or mu_i<0) then
            s[1]:=0;
            s[2]:=Modelica.Constants.inf;
          else
            if s[1] <=0 then
              s[1]:=Modelica.Constants.inf;
            end if;
            if s[2] <=0 then
              s[2]:=Modelica.Constants.inf;
            end if;
          end if;
         sol[i]:=min(s[1],s[2]);
        end for;
        sigma_o:=min(sol[1], sol[2]);
      end getSigmaDext;

    // wrapper functions for the various variables of the internal transition
      function getSigmaDint
        input Real quantum_i;
        input Real sigma_i;
        input Real u_i;
        input Real mu_i;
        input Real pu_i;
        input Real xl_i;
        input Real xu_i;
        output Real sigma_o;
      protected
        Real sigma_p;
        Real xl_p;
        Real xu_p;
        Real u_p;
      algorithm
        (sigma_p,xl_p,xu_p,u_p):=internalTransition(quantum_i, sigma_i, u_i, mu_i, pu_i, xl_i, xu_i);
        sigma_o:=sigma_p;
      end getSigmaDint;

      function getXlDint
        input Real quantum_i;
        input Real sigma_i;
        input Real u_i;
        input Real mu_i;
        input Real pu_i;
        input Real xl_i;
        input Real xu_i;
        output Real xl_o;
      protected
        Real sigma_p;
        Real xl_p;
        Real xu_p;
        Real u_p;
      algorithm
        (sigma_p,xl_p,xu_p,u_p):=internalTransition(quantum_i, sigma_i, u_i, mu_i, pu_i, xl_i, xu_i);
        xl_o:=xl_p;
      end getXlDint;

      function getXuDint
        input Real quantum_i;
        input Real sigma_i;
        input Real u_i;
        input Real mu_i;
        input Real pu_i;
        input Real xl_i;
        input Real xu_i;
        output Real xu_o;
      protected
        Real sigma_p;
        Real xl_p;
        Real xu_p;
        Real u_p;
      algorithm
        (sigma_p,xl_p,xu_p,u_p):=internalTransition(quantum_i, sigma_i, u_i, mu_i, pu_i, xl_i, xu_i);
        xu_o:=xu_p;
      end getXuDint;

      function getUdint
        input Real quantum_i;
        input Real sigma_i;
        input Real u_i;
        input Real mu_i;
        input Real pu_i;
        input Real xl_i;
        input Real xu_i;
        output Real u_o;
      protected
        Real sigma_p;
        Real xl_p;
        Real xu_p;
        Real u_p;
      algorithm
        (sigma_p,xl_p,xu_p,u_p):=internalTransition(quantum_i, sigma_i, u_i, mu_i, pu_i, xl_i, xu_i);
        u_o:=u_p;
      end getUdint;

      function internalTransition
        input Real quantum_i;
        input Real sigma_i;
        input Real u_i;
        input Real mu_i;
        input Real pu_i;
        input Real xl_i;
        input Real xu_i;
        output Real sigma_o;
        output Real xl_o;
        output Real xu_o;
        output Real u_o;
      protected
        Real s[2];
        Real sol[2];
        Real c;
        Real xl_p;
        Real xu_p;
        Real u_p;
        Real mu_p;
      algorithm
        xl_p:=xl_i;
        xu_p:=xu_i;
        u_p:=u_i;
        mu_p:=mu_i;
        s[1]:=Modelica.Constants.inf;
        s[2]:=Modelica.Constants.inf;
        sol[1]:=Modelica.Constants.inf;
        sol[2]:=Modelica.Constants.inf;

        if sigma_i==0 then
          if u_p==xu_p and (mu_i>0 or (mu_i==0 and pu_i>0)) then
            xl_p:=xu_p;
            xu_p:=xl_p + quantum_i;
          end if;
        else
          if u_p+mu_i*sigma_i+pu_i*sigma_i*sigma_i >(xu_p+xl_p)/2 then
            xu_p:=xu_p + quantum_i;
            xl_p:=xl_p + quantum_i;
          else
            xu_p:=xu_p - quantum_i;
            xl_p:=xl_p - quantum_i;
          end if;
          u_p:=u_p + mu_i*sigma_i + mu_i*sigma_i*sigma_i;
          mu_p:=mu_p+2*pu_i*sigma_i;

          if u_p<(xu_p+xl_p)/2 then
            u_p:=xl_p;
          else
            u_p:=xu_p;
          end if;
        end if;

        for i in 1:2 loop
          if (i==1) then
            c:=u_p - xu_p;
          else
            c:=u_p - xl_p;
          end if;

          if pu_i == 0 then
            if mu_p<>0 then
              s[1]:=-c/mu_p;
            else
              sigma_o:=Modelica.Constants.inf;
            end if;
          else
            if mu_p*mu_p > 4*pu_i*c then
              s[1]:=(-mu_p + sqrt(mu_p*mu_p - 4*pu_i*c))/(2*pu_i);
              s[2]:=(-mu_p - sqrt(mu_p*mu_p - 4*pu_i*c))/(2*pu_i);
            end if;
          end if;

          if u_p==xl_p and ((mu_p==0 and pu_i<0) or (sigma_i==0 and mu_p<0)) then
            xl_p:=xl_p - quantum_i;
            xu_p:=xu_p - quantum_i;
            s[1]:=0;
            s[2]:=Modelica.Constants.inf;
          else
            if s[1] <=0 then
              s[1]:=Modelica.Constants.inf;
            end if;
            if s[2]<=0 then
              s[2]:=Modelica.Constants.inf;
            end if;
          end if;
          sol[i]:=min(s[1],s[2]);
        end for;
        sigma_o:=min(sol[1], sol[2]);
        xl_o:=xl_p;
        xu_o:=xu_p;
        u_o:=u_p;
      end internalTransition;

    /*************************************************************/
    /**********************   EQUATIONS   ************************/
    /*************************************************************/

    equation
      dint= time >= pre(lastTime)+pre(sigma);
      dext= uEvent;
      yEvent=edge(dint);

      when {dint} then
        yVal[1]= if pre(sigma) == 0 then pre(xl) else if (pre(u)+pre(mu)*pre(sigma)+pre(pu)*pre(sigma)*pre(sigma) > (pre(xu)+pre(xl))/2) then pre(xl)+quantum else pre(xl)-quantum;
        yVal[2]= 0;
        yVal[3]= 0;
      end when;

      when {dint,dext} then
        if dint then
          xl=getXlDint(quantum, pre(sigma), pre(u), pre(mu), pre(pu), pre(xl), pre(xu));
          xu=getXuDint(quantum, pre(sigma), pre(u), pre(mu), pre(pu), pre(xl), pre(xu));
          sigma=getSigmaDint(quantum, pre(sigma), pre(u), pre(mu), pre(pu), pre(xl), pre(xu));
          u=getUdint(quantum, pre(sigma), pre(u), pre(mu), pre(pu), pre(xl), pre(xu));
          mu= pre(mu);
          pu= pre(pu);
        else
          u = uVal[1];
          mu= uVal[2];
          pu= uVal[3];
          if u>=pre(xu) or u<pre(xl) then
            xl=floor(u/quantum)*quantum;
            xu= xl+quantum;
            sigma=0;
          else

            xl=pre(xl);
            xu=pre(xu);
            sigma=getSigmaDext(u, mu, pu, xl, xu);
          end if;
        end if;
         lastTime=time;
      end when;

      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-14; -30,-14; -30,20; 10,20; 10,66; 66,66],   style(
                color=3, rgbcolor={0,0,255}))), DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Quantiser Block </b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>quantum</b></td>
<td>output quantisation degree</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
A quantiser relates its inputs and outputs by a quantisation function as defined in the <a href=\"Modelica://ModelicaDEVS.UsersGuide.QSS\"> Quantised State Systems</a> section. In the particular case of ModelicaDEVS/PowerDEVS, the Quantiser block is a non-hysteretic function similar to floor() that maps the input signal to the quantisation levels that are equidistantly distributed at values Q<sub>k</sub>= &plusmn; k*quantum with k=non-negative integers.
<br/>
In other words, if we assume a quantum value of 0.1, then the y-axis can be thought to be \"cut\" into slices of height 0.1, since the quantisation levels are located at values of y=0.1*i for i=non-negative integers - at equidistant y-values starting from zero in both the positive and negative directions. The Quantiser block generates an output event whenever the input signal crosses a quantisation level. The output event takes the value of the current function value; hence it is a multiple of the quantum parameter value.
<br/>
Note that this block is somewhat similar to the CrossDetect block, that however has a fixed output value and only a single level where crossings have to be detected.
<br/>
<br/>
The subsequent picture shows a sine signal quantised with a quantum of 0.4. The sine signal itself is plotted in blue, the quantised version in red.
<br/>
<br/>
<center><img src=\"../Images/OutQuantiser.png\"></center>
</html>"));
    end Quantiser;

    block Saturation "Truncates the input signal at a certain level."
      extends ModelicaDEVS.Templates.DDBlock(final method=3);
      parameter Real vU=1 "Upper value";
      parameter Real vL=-1 "Lower value";

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      discrete Real e;
      discrete Real level1(start=0);
      discrete Real level2(start=0);
      discrete Real uEstimate(start=(vU+vL)/2);
      discrete Real u(start=0); //current Input
      discrete Real mu(start=0); //slope of u
      discrete Real pu(start=0); //slope of mu
      Boolean dint;
      Boolean dext;

    function getSigma
        input Real u_i;
        input Real mu_i;
        input Real pu_i;
        input Real vL_i;
        input Real vU_i;
        output Real sigma_o;
      protected
        Real s[2];
        Real sol[2];
        Real c;
    algorithm
        s[1]:=Modelica.Constants.inf;
        s[2]:=Modelica.Constants.inf;
        sol[1]:=Modelica.Constants.inf;
        sol[2]:=Modelica.Constants.inf;

        for i in 1:2 loop
          if (i==1) then
            c:=u_i - vL_i;
          else
            c:=u_i - vU_i;
          end if;

          if pu_i == 0 then
            if mu_i<>0 then
              s[1]:=-c/mu_i;
            end if;
          else
            if mu_i*mu_i > 4*pu_i*c then
              s[1]:=(-mu_i + sqrt(mu_i*mu_i - 4*pu_i*c))/(2*pu_i);
              s[2]:=(-mu_i - sqrt(mu_i*mu_i - 4*pu_i*c))/(2*pu_i);
            end if;
          end if;

          if s[1] <=0 then
            s[1]:=Modelica.Constants.inf;
          end if;
          if s[2]<=0 then
            s[2]:=Modelica.Constants.inf;
          end if;
          sol[i]:=min(s[1],s[2]);
        end for;
        sigma_o:=min(sol[1], sol[2]);
    end getSigma;

    equation
      assert(vU>vL, "Saturation block: vU (the upper limit value) should be bigger than vL (the lower limit value)");

      dint= time >= pre(lastTime)+pre(sigma);
      dext= uEvent;
      yEvent=edge(dint);

      when {dint} then
        yVal[1]= if pre(sigma)<>0 or pre(level2)<>1 then if pre(u)+pre(mu)*pre(sigma)+pre(pu)*pre(sigma)*pre(sigma) > (vU+vL)/2 then vU else vL else pre(u);
        yVal[2]= if (yVal[1] >= vU and (pre(mu)+2*pre(pu)*pre(sigma)>0 or (pre(mu)+2*pre(pu)*pre(sigma)==0 and pre(pu)>0))) or
                    (yVal[1] <= vL and (pre(mu)+2*pre(pu)*pre(sigma)<0 or (pre(mu)+2*pre(pu)*pre(sigma)==0 and pre(pu)<0))) then 0 else pre(mu)+2*pre(pu)*pre(sigma);
        yVal[3]= if (yVal[1] >= vU and (pre(mu)+2*pre(pu)*pre(sigma)>0 or (pre(mu)+2*pre(pu)*pre(sigma)==0 and pre(pu)>0))) or
                    (yVal[1] <= vL and (pre(mu)+2*pre(pu)*pre(sigma)<0 or (pre(mu)+2*pre(pu)*pre(sigma)==0 and pre(pu)<0))) then 0 else pre(pu);
      end when;

      when {dint,dext} then
        e=time-pre(lastTime);
        if dint then
          uEstimate=pre(uEstimate);
          u = if pre(sigma)<>0 then if pre(u)+pre(mu)*pre(sigma)+pre(pu)*pre(sigma)*pre(sigma) < (vU+vL)/2 then vL else vU else pre(u);
          mu= if pre(sigma)<>0 then pre(mu)+2*pre(pu)*pre(sigma) else pre(mu);
          pu=pre(pu);
          level1=pre(level1);
          level2=pre(level2);
          sigma= getSigma(u, mu, pu, vL, vU);
        else
          uEstimate=pre(u) + pre(mu)*e + pre(pu)*e*e;
          u= uVal[1];
          mu= uVal[2];
          pu=uVal[3];
          level1=if uEstimate < vL then 0 else if uEstimate > vU then 2 else 1;
          level2=if u < vL then 0 else if u > vU then 2 else 1;
          sigma=if u<=vU and u>= vL or level1 <> level2 then 0 else getSigma(u,mu,pu,vL,vU);
        end if;

        lastTime=time;
      end when;

      annotation (Icon(
          Line(points=[-92,0; -90,0; 90,0],       style(color=0, rgbcolor={0,0,0})),
          Line(points=[-6,88; -6,-88],   style(color=0, rgbcolor={0,0,0})),
          Line(points=[-86,-58; -42,-58; 30,58; 88,58], style(color=3, rgbcolor={0,
                  0,255}))),                    DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Saturation Block </b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>vU</b></td>
<td>upper saturation value</td>
</tr>
<tr>
<td><b>vL</b></td>
<td>lower saturation value</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
This block basically just propagates the input signal to its output port, but - as its name suggests - truncates it if it takes values outside a certain region. The band where the signal is forwarded without any modification, is defined by the two parameters vL and vU.
<br/>
<br/>
Note that it makes no sense to interchange the upper and lower saturation value. Therefore, ModelicaDEVS guards against such a situation by using the assert() function to stop the compilation of the model and print out an error message for the user in case of vL > vU.
<pre>
equation
  assert(vU>vL, \"Saturation block: vU should be bigger than vL\");
  ...[usual instructions for block behaviour]...
</pre>
<br/>
<br/>
The picture below shows a sine signal (blue) and its truncated version (red). The saturation values are vU=1 and vL=-1.
<br/>
<br/>
<center><img src=\"../Images/OutSaturation.png\"></center>
</html>"));
    end Saturation;

    block Sin "Generates an output y=sin(u)."
      extends ModelicaDEVS.Templates.DDBlock(final method=3);

    protected
      discrete Real lastTime(start=0);
      discrete Real sigma(start=Modelica.Constants.inf);
      Boolean dext;
      Boolean dint;

    equation
      dint= time >= pre(lastTime)+pre(sigma);
      dext= uEvent;
      yEvent=edge(dint);

      when {dint} then
        yVal[1]=sin(uVal[1]);
        yVal[2]=if method>1 then uVal[2]*cos(uVal[1]) else 0;
        yVal[3]=if method>2 then -0.5*uVal[2]*sin(uVal[1]) + uVal[3]*cos(uVal[1]) else 0;
      end when;

      when {dext, dint} then
        sigma=if dint then Modelica.Constants.inf else 0;
        lastTime=time;
      end when;

      annotation (Icon(
          Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,0; -61.6,34.2; -56.1,53.1; -51.3,66.4; -47.1,74.6; -42.9,
                79.1; -38.64,79.8; -34.42,76.6; -30.201,69.7; -25.98,59.4; -21.16,
                44.1; -16,22; -2.5,-30.8; 3,-50.2; 7.8,-64.2; 12,-73.1; 16.2,-78.4;
                20.5,-80; 24.7,-77.6; 28.9,-71.5; 33.1,-61.9; 37.9,-47.2; 44,-24.8;
                66,64], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-92,0; -90,0; 78,0],       style(color=0, rgbcolor={0,0,0}))),
                                                DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Sin Block </b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>g</b></td>
<td>gain value</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Sin block belongs to the group of unary operator blocks. It computes the sine value of an input signal: y=sin(u).
<br/>
<br/>
Unary operator blocks are very simple in their structure: they only take one input, apply a function and pass the result to the next block. Their internal and external transition merely consist of setting sigma to infinity or zero respectively.
<br/>
Given that these blocks only depend on external events and lack a proper internal transition (it simply consists of setting the value of sigma to infinity), their behaviour could be described by a single when-statement that would become active when dext becomes true. But this a) would not correspond to the DEVS formalism, which defines both an external and an internal transition, and b) could cause algebraic loops when connected in a cycle with a Comparator block.
</html>"));
    end Sin;

    model Switch "Switches between the first and third input port."
      extends ModelicaDEVS.Templates.TripleDDBlock(final method=3);
      parameter Real level=0 "Switching level.";

      Comparator Comparator2(
        method=3,
        Vu=0,
        Vl=1)                annotation (extent=[-20,-40; 0,-20]);
      Comparator Comparator1(
        Vl=0,
        Vu=1,
        method=3)            annotation (extent=[-20,20; 0,40]);
      annotation (Diagram, Icon(
          Line(points=[-100,60; -36,60], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-100,-60; -36,-60], style(color=3, rgbcolor={0,0,255})),
          Line(points=[36,0; 100,0], style(color=3, rgbcolor={0,0,255})),
          Ellipse(extent=[-40,66; -30,56], style(color=3, rgbcolor={0,0,255})),
          Ellipse(extent=[-40,-54; -30,-64], style(color=3, rgbcolor={0,0,255})),
          Ellipse(extent=[26,6; 36,-4], style(color=3, rgbcolor={0,0,255})),
          Line(points=[26,0; -30,60], style(color=3, rgbcolor={0,0,255})),
          Line(points=[-100,0; -36,0], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-36,8; -36,-8], style(color=0, rgbcolor={0,0,0}))),
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Switch Block </b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>level</b></td>
<td>switching level</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The Switch block can be thought to direct either the first or the third input port to its output port. The second input port takes the decision which of the input ports is actually propagated: if the value of the second input port is bigger than a given level, the Switch propagates the first input port, otherwise the third one.
<br/>
<br/>

Contrary to PowerDEVS, where this block is an atomic model, ModelicaDEVS makes use of the fact that the DEVS formalism allows for hierarchical models: by putting a multi-component model into one of the predefined block hull templates it can be used as a normal block for further models. The interior life of the Switch block looks as shown in the following figure:
<br/>
<br/>
<center><img src=\"../Images/SwitchInner.png\" width=\"400\"></center>
<br/>
<br/>
Let us have a look at the purpose of each of the internal blocks.
<ul>
<li>
The Constant block represents the level to which the second port is compared. Note that since the level is set by the user by means of a parameter (parameter Real level=0 \"Switching level.\";), this value has to be passed to the Constant block which yields the following declaration: Sources.Constant Constant1(v=level).
</li>
<li>
The two Comparator blocks evaluate if the value of the second input port is above or below the specified level. To this end, the upper comparator emits an output value of 1 if the value of the second port is bigger than the level and 0 otherwise. The lower Comparator emits an output value of 1 if the value of the second port is smaller or equal than the level and 0 otherwise. In other terms, the Comparators declare which of the two switch input signals (port 1 or port 3) to propagate to the output port: if for instance, the upper comparator emits 0, the lower one by definition emits 1 and vice-versa.
<br/>
Note the settings of the output values of the Comparators: Comparator1.vU = 1, Comparator1.vL = 0, Comparator2.vU = 0, Comparator2.vL = 1.
</li>
<li>
The Multiplier blocks receive the input of the first and the third port, respectively, and a value of the Comparators that determines whether the particular input signal has to be multiplied by 0 or 1. If, for instance, the input of the second Switch port is smaller or equal than the specified level, the upper Comparator emits 0 and the lower one emits 1. Hence, the signal of the third port would be forwarded since its value is multiplied by 1 whereas the upper one is zeroed-out by multiplying its value by 0.
</li>
<li>
The Add block merges the two outputs coming from the Multiplier blocks (one of which is always zero and the other one carries the value from one of the input ports of the Switch block).
</li>
</ul>
The two pictures below illustrate the behaviour of a Switch block.
<br/>
<br/>
The first picture shows the trajectory of the second input port (a sine signal plotted in blue) and the switching level (red) given by the parameter level. The crossing instants of the sine signal with the switching level determines the time instants when the Switch has to flip, thereby changing the source (port 1 or port 3) for its output port.
<br/>
<br/>
<center><img src=\"../Images/OutSwitch1.png\"></center>
<br/>
<br/>
The second picture shows the first input port (blue) that is simply a constant value at v=3 and the third input port that is a sine signal that starts only at time t=0.8. The output of the Switch block is then plotted in red. It can be easily seen that when the sine signal in the first picture is bigger than the switching level, the output is constant at the value 3, and when the sine signal drops below the switching level, the Switch output equals the trajectory of the sine signal of the third input port.
<br/>
<br/>
<center><img src=\"../Images/OutSwitch2.png\"></center>
<br/>
<br/>
</html>"));
      Multiplier Multiplier1 annotation (extent=[20,46; 40,66]);
      Multiplier Multiplier2 annotation (extent=[20,-66; 40,-46]);
      Add Add1(method=3)
               annotation (extent=[60,-10; 80,10]);
      SourceBlocks.Constant Constant1(v=level)
                                 annotation (extent=[-76,-10; -56,10]);
    equation
      connect(inPort2, Comparator1.inPort1) annotation (points=[-120,0; -80,0; -80,
            34; -22,34], style(color=3, rgbcolor={0,0,255}));
      connect(inPort3, Multiplier2.inPort2) annotation (points=[-120,-60; 18,-60],
                              style(color=3, rgbcolor={0,0,255}));
      connect(inPort1, Multiplier1.inPort1) annotation (points=[-120,60; 18,60],
                            style(color=3, rgbcolor={0,0,255}));
      connect(Comparator1.outPort, Multiplier1.inPort2) annotation (points=[2,30; 10,
            30; 10,52; 18,52],
                           style(color=3, rgbcolor={0,0,255}));
      connect(Comparator2.outPort, Multiplier2.inPort1) annotation (points=[2,-30;
            12,-30; 12,-52; 18,-52], style(color=3, rgbcolor={0,0,255}));
      connect(Multiplier1.outPort, Add1.inPort1) annotation (points=[42,56; 48,56;
            48,4; 58,4], style(color=3, rgbcolor={0,0,255}));
      connect(Multiplier2.outPort, Add1.inPort2) annotation (points=[42,-56; 48,-56;
            48,-4; 58,-4],
                    style(color=3, rgbcolor={0,0,255}));
      connect(Constant1.outPort, Comparator1.inPort2) annotation (points=[-54,0;
            -34,0; -34,26; -22,26],  style(color=3, rgbcolor={0,0,255}));
      connect(Add1.outPort, outPort)
        annotation (points=[82,0; 120,0], style(color=3, rgbcolor={0,0,255}));
      connect(inPort2, Comparator2.inPort1) annotation (points=[-120,0; -80,0; -80,
            -26; -22,-26], style(color=3, rgbcolor={0,0,255}));
      connect(Constant1.outPort, Comparator2.inPort2) annotation (points=[-54,0;
            -34,0; -34,-34; -22,-34], style(color=3, rgbcolor={0,0,255}));
    end Switch;

    annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Function Blocks</b></font>
<br/>
<br/>
The function blocks are described by means of a listing of their parameters and the output they generate in a specific model.
<br/>
<br/>
Additionally, a short textual description is provided, in order to cover possible particularities of the single blocks.
</html>"));
  end FunctionBlocks;

  package SinkBlocks "Sink Blocks"
    block Interpolator "Interpolates the output of an Integrator block. "
      extends ModelicaDEVS.Templates.DCBlock;

    protected
      discrete Real lastTime(start=0);
      Boolean update(start=false);

    public
    function interpolate
      input Real coeff1;
      input Real coeff2;
      input Real coeff3;
      input Real coeff4;
      input Real epsilon;
      output Real val;

      annotation(derivative=der_interpolate);
    algorithm
      val:=coeff1 + coeff2*epsilon + coeff3*epsilon*epsilon + coeff4*epsilon*epsilon*epsilon;
    end interpolate;

    function der_interpolate
      input Real coeff1;
      input Real coeff2;
      input Real coeff3;
      input Real coeff4;
      input Real epsilon;
      input Real der_coeff1;
      input Real der_coeff2;
      input Real der_coeff3;
      input Real der_coeff4;
      input Real der_epsilon;
      output Real der_val;

      annotation(derivative(order=2)=der_2_interpolate);
    algorithm
      der_val:=coeff2 + 2*coeff3*epsilon + 3*coeff4*epsilon*epsilon;
    end der_interpolate;

    function der_2_interpolate
    input Real curVal_i;
      input Real coeff1;
      input Real coeff2;
      input Real coeff3;
      input Real coeff4;
      input Real epsilon;
      input Real der_coeff1;
      input Real der_coeff2;
      input Real der_coeff3;
      input Real der_coeff4;
      input Real der_epsilon;
      input Real der_2_coeff1;
      input Real der_2_coeff2;
      input Real der_2_coeff3;
      input Real der_2_coeff4;
      input Real der_2_epsilon;
      output Real der_2_val;
    algorithm
      der_2_val:=2*coeff3 + 6*coeff4*epsilon;
    end der_2_interpolate;

    equation
      update= uEvent;

      when update then
        lastTime=time;
      end when;

      y= if method > 2 then interpolate(uVal[1], uVal[2], uVal[3], uVal[4], time-lastTime) else
         if method > 1 then interpolate(uVal[1], uVal[2], uVal[3], 0, time-lastTime) else
         interpolate(uVal[1], uVal[2], 0, 0, time-lastTime);
      annotation (Icon(
          Line(points=[-70,80; -70,-90], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-30; -30,-30; -30,4; 10,4; 10,50; 66,50], style(color=9,
                rgbcolor={175,175,175})),
          Line(points=[66,50; 66,80], style(color=9, rgbcolor={175,175,175})),
          Line(points=[-70,-30; -30,4; 10,50; 66,80], style(color=3, rgbcolor={0,0,
                  255}))), Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The Interpolator Block </b></font>
<br/>
<br/>
The following sections discuss the need/advantage of the Interpolator block, and show how it works.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>The Interpolator as a simple Interface</b></font>
<br/>
<br/>
One of the Interpolator's purposes is to provide an interface from a ModelicaDEVS model to a conventional Modelica model by transforming the signals coming from DEVS blocks into signals for non-DEVS blocks. Given that DEVS blocks have input and output ports consisting of a vector of size four (see the section about <a href=\"Modelica://ModelicaDEVS.UsersGuide.ModelicaDEVS.Theory\"> ModelicaDEVS</a> for a syntactically correct description of ports), whereas normal Modelica blocks have scalar inputs and outputs, the first task of the interpolator is a simple type conversion, such that DEVS signals can be passed to other Modelica blocks.
<br/>
The Interpolator can be said to be the counterpart to the sampler blocks, which take a signal of type real and transform it into a DEVS event.
<br/>
<br/>
The simplest way to pass a DEVS-input-signal to a conventional Modelica block is to just forward a truncated version of the input DEVS vector, namely its first entry.
<br/>
<br/>
The next section shows however why this approach is not the best one possible, and why it is more advantageous to slightly change the input signal before passing it to the next block.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Function Smoothening</b></font>
<br/>
<br/>
The second purpose of the Interpolator (apart from the type conversion) is to smoothen the piecewise constant trajectory of DEVS state variables. Of course, conventional Modelica blocks are able to process a piecewise constant signal, but this would yield a very poor approximation of the true function.
<br/>
Remember that simulating a continuous system using the DEVS formalism means to numerically approximate the theoretical trajectories of the state variables. The output values generated by DEVS blocks are then points on that approximating curve. When displayed in Dymola, the output points are connected by piecewise constant straight lines and thus give rise to the well known piecewise constant output function of ModelicaDEVS blocks. Note that given the discrete nature of the state variables, these stair-like trajectories are a precise reproduction of the virtual block behaviour: the state variables keep a certain value for a given amount of time and then jump to another value:
<br/>
<br/>
<center><img src=\"../Images/HoldJump.png\"></center>
<br/>
<br/>
A smoother approximation of the true function could be obtained if we were to interpolate two output values by a higher-order curve than a piecewise constant function.
<br/>
Unfortunately, given the aforementioned discrete nature of the state variables, it makes no sense for Dymola to connect two output events by a straight line, or even a quadratic or cubic curve. So, if we want to have smoother output, we have to interpolate \"by ourselves\":
<br/>
<br/>
<center><img src=\"../Images/Interpolate.png\"></center>
<br/>
<br/>
Interpolation in this case results in a function consisting of consecutive interpolation segments that are of a higher approximation order than a piecewise constant function.
<br/>
<br/>
For an illustration of the output of an Interpolator (connected to an Integrator) see the subsequent figure, where the green line is the discrete output of the integrator, the red line is the (linear) interpolation and the blue line is the real solution, computed with the DASSL method of Dymola. The simulated model is the one shown in Figure \\ref{fig:example11}.
<br/>
<br/>
<center><img src=\"../Images/Interpolator.png\"></center>
<br/>
<br/>
After having established the advantages of an Interpolator component, it will now be explained in more detail how it works. Since the Integrator is the only block the output of which is meaningful to interpolate, let us examine the collaboration of an Interpolator that receives signals from an Integrator block. For simplicity reasons, we shall only consider the first-order case where the connection between two output points are straight lines. Quadradic and cubic interpolation works analogously.
<br/>
<br/>
Two points x and x(t+h) can be linearly connected if x and the first derivative dx/dt are known. Hence, this information has to be given to the Interpolator, in order to make it able to interpolate the output of the Integrator.
<br/>
Given that the input of an Integrator block is the derivative of its output, the QSS1 (linear approximation) Integrator passes the current function value X and its own input value uVal[1] to the Interpolator.
<pre>
yIntVal[1]= X;       //coefficient of the constant term of the Taylor series
yIntVal[2]= uVal[1]; //coefficient of the linear term of the Taylor series
yIntVal[3]= 0;       //coefficient of the quadratic term of the Taylor series
yIntVal[4]= 0;       //coefficient of the cubic term of the Taylor series
</pre>
From these values the Interpolator is able to compute the trajectory from the current to the next output value of the Integrator (note that the instructions shown above are not actual code of the Interpolator block. At this point however, they are probably more suited to illustrate the way the Interpolator works than the real formulae would be):
<center><pre> y=uVal[1] + uVal[2]*(time-pre(lastTime));</pre></center>
where Interpolator.uVal[1] contains Integrator.X, and Interpolator.uVal[2] contains the value of Integrator.uVal[1].
<br/>
Note that by passing the values X and uVal[1] to the Interpolator, the Integrator implicitly assumes that there will be no external event between the current event and the next internal one. This assumption is too simplifying of course, but it is the only possible approximation. In the case however that the Integrator indeed has to execute an external transition before it reaches the moment when - according to the value of sigma - it would have to execute its next internal transition, the slope of the interpolation probably changes, because due to the external transition that the Integrator has to execute, also the value of uVal[1] is likely to change. Thus, in the case of an external event, the Integrator simply sends a new set of X and uVal[1] to the Interpolator, in order to inform it about the changed situation.
<br/>
At every arrival of an external event, the Interpolator interrupts the current simulation, adjusts the value of the interpolation slope to the new value received from the Integrator, and restarts the interpolation applying the new slope.
<br/>
<br/>
<center><img src=\"../Images/InterpolatorWork.png\" width=\"500\"></center>
<br/>
<br/>
<br/>
The above figure sketches a scenario where an Integrator executes internal transitions at time instants t=0, t=1, t=3 and t=6 and receives an external event at t=4. At every step, the illustration shows the output vector that the Integrator passes to the Interpolator. The variable yVal[1] holds the actual integration value, yVal[2] stores the first derivative (which is equal to the Integrator's input port uVal[1]).
<br/>
The trajectory of the Interpolator until t=3 is rather easy to comprehend. At t=3 however the output of the Integrator reaches a value of 4, the estimated next value would be 5, reached in 2 more time steps (&sigma;=2). While the Integrator is \"waiting\" for these two time steps to pass, it receives an external event, so uVal[1] is updated (from 0.5 to 1.5), and by executing the external transition also X changes (from 4 to 4.5). When the Interpolator receives the new (external) event at t=4, it substitutes the old interpolation slope by the new one. We can identify this substitution by the buckling in the trajectory of the last picture in the figure at time t=4.
<br/>
<br/>
<br/>
<font color=\"#0000FF\"><b>Interpolator Specific Ports</b></font>
<br/>
<br/>
Given that the Interpolator cannot work with the normal output vectors of DEVS blocks, but requires additional information about the possible future state trajectory, the Integrator features a second output port supplementary to the common one. Through this port, the Integrator emits events consisting of the following four values:
<ul>
<li>
The current value of the signal that is equal to the first entry of the normal output vector.
</li>
<br/>
<br/>
<li>
The coefficient of the linear term of the Taylor series expansion; in other words, the first derivative.
</li>
<br/>
<br/>
<li>
The coefficient of the quadratic term of the Taylor series expansion; in other words, the second derivative divided by 2.
</li>
<br/>
<br/>
<li>
The coefficient of the cubic term of the Taylor series expansion; in other words, the third derivative divided by 6. <br/>
Note that the third derivative of the Integrator output can be obtained by means of the third entry of the input vector: since the task of the Integrator block is to integrate the input function, the Integrator input vector can be thought of as the derivative (component-wise) of the output vector. As stated before, the output vector of a block holds the coefficients of the first three terms of the Taylor series, this means in particular that the third entry contains the second derivative devided by two. To the Integrator, this third entry looks like the \\textbf{third} derivative devided by two. Hence, in order to pass the third derivative devided by six to the Interpolator, the Integrator simply devides the third entry of its input port by 3. The following figure illustrates this circumstance:
<br/>
<br/>
<center><img src=\"../Images/IntegratorInputOutput.png\" width=\"300\"></center>
</li>
<li>
The usual boolean value, which informes the Interpolator that block X has just generated an output event that needs to be processed.
</li>
</ul>
The dissimilarity of the normal output/input vectors and the special vector that is required by the Interpolator is also highlighted graphically in the layout of the blocks: instead of the common blue input ports, the Interpolator has a red input port that is connectable only to the red output port of the Integrator.
<br/>
<br/>
</html>"));

    end Interpolator;

    block InterpolatorTest
      "Dummy block to test the user defined derivatives in the Interpolator."
      extends ModelicaDEVS.SinkBlocks.Interpolator;

    protected
      Real s;

    equation
      der(s)=der(y);

    initial equation
      s=y;
      annotation (Icon(
          Line(points=[-70,80; -70,-90], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
          Line(points=[-70,-30; -30,-30; -30,4; 10,4; 10,50; 66,50], style(color=9,
                rgbcolor={175,175,175})),
          Line(points=[66,50; 66,80], style(color=9, rgbcolor={175,175,175})),
          Line(points=[-70,-30; -30,4; 10,50; 66,80], style(color=3, rgbcolor={0,0,
                  255}))), Diagram,
        Documentation(info="<html>
<p>
<font color=\"#0000FF\" size=5><b>The InterpolatorTest Block </b></font>
<br/>
<br/>
The purpose of this block is to test the user defined derivatives declared in the Interpolator block.
</p>

</html>"));
    equation

    end InterpolatorTest;

    annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Sink Blocks </b></font>
<br/>
<br/>
The package of sink blocks consists of only one component: the Interpolator.
<br/>
<br/>
It may seem a bit strange that, although it produces output, the Interpolator claims to be a sink. This is however justified considering the fact that even if it accepts DEVS signals, it does not generate any and therefore looks like a sink to a DEVS model. It only produces output targeted at non-DEVS models.
</html>"));
  end SinkBlocks;

  package Miscellaneous "Miscellaneous"

    model worldModel "Set QSS mode for all blocks in a model."
      extends ModelicaDEVS.Templates.BlockIcon;
      parameter Integer qss=1;

      annotation (defaultComponentName="world", defaultComponentPrefixes="inner", Diagram,
        Icon(
          Text(
            extent=[-58,90; 62,24],
            string="QSS1",
            style(
              color=74,
              rgbcolor={0,0,211},
              thickness=2)),
          Text(
            extent=[-58,-30; 62,-96],
            string="QSS3",
            style(color=1, rgbcolor={255,0,0})),
          Text(
            extent=[-58,30; 62,-36],
            string="QSS2",
            style(color=6, rgbcolor={255,255,0}))),
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>The WorldModel Component </b></font>
<br/>
<br/>
<font color=\"#0000FF\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>qss</b></td>
<td>choose QSS mode</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#0000FF\"><b>Description:</b></font>
<br/>
<br/>
The WorldModel component is a very simple, equation-less model that consists of only one parameter:
<pre>
model worldModel
  extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Integer qss=1;
equation
  ...[annotation]...
end worldModel;
</pre>
It has to be inserted in every model, and its parameter qss is used to set the parameter $method$ in the model's others components.<br/>
But how is it possible to set a parameter by means of a parameter of another component? The solution in this context is the Modelica \"inner/outer\" language construct (cf. [Modelica]): <i>\"If a variable or a component is declared as outer, the actual instance is defined outside of the defining class and is determined by searching the object hierarchy upwards until a corresponding declaration with the inner prefix is found.\"</i>
<br/>
Every block contains therefore an outer variable world of the type worldModel and uses the variable world.qss in order to set the parameter method:
<pre>
model anyBlock

  parameter Integer method=world.qss \"Use QSS1, QSS2 or QSS3\";
  outer ModelicaDEVS.Templates.worldModel world;
</pre>
By definition, the model itself has to contain a component called $world$ of the type worldModel that is declared as \"inner\". In order to automatically guarantee these settings for all instances of the WorldModel component, the WorldModel features the following annotation properties:
<pre>
annotation (defaultComponentName=\"world\",
            defaultComponentPrefixes=\"inner\",
            Diagram,
            Icon([Icon definitions])
);
</pre>
The true value of method in any block that is present in a model that also contains the WorldModel is then determined by the WorldModel.qss parameter. Assume a simple toy model, only consisting of a Ramp block and the compulsory WorldModel component. The figure below shows how the method parameter of the Ramp block is defined by setting the qss parameter of the component world:
<br/>
<br/>
<br/>
<center>
<table>
<tr>
<td><center><img src=\"../Images/WorldModel_worldModel.png\" width=\"300\"></center></td>
<td><center><img src=\"../Images/WorldModel_Ramp.png\" width=\"300\"></center></td>
</tr>
</table>
</center>
<br/>
<br/>
<br/>
The method parameter determines whether to use QSS1, QSS2 or QSS3 specifications. The presence of the WorldModel component allows the user to switch the method parameter of all blocks in a model at once instead of being forced to switch it for each block separately. Then again, it is still possible to assign a fixed value to the method parameter of certain blocks if this is desired: simply open the parameter window of the block in question and modify the parameter $method$ manually. Thereby, method becomes independent of world.qss, and hence, a modification of qss in the WorldModel will not effect it anymore.
<br/>
<br/>
Note that blocks that lack a parameter method produce output events that are valid for any type of QSS, and are never influenced by the WorldModel.
<br/>
<br/>
</html>"));
    end worldModel;
    annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Miscellaneous</b></font>
<br/>
<br/>
The Miscellaneous package contains all models that do not belong to one of the other packages.
<br/>
<br/>
Currently, there is only the WorldModel in this package.
</html>"));
  end Miscellaneous;

  package Templates "Block and Connector Templates"
    connector DiscreteInPort "DEVS input connector"
      annotation (
        uses(Modelica(version="1.6")),
        Diagram,
        Icon(Polygon(points=[-100,100; 100,0; -100,-100; -100,100], style(
              color=3,
              rgbcolor={0,0,255},
              gradient=3,
              fillColor=3,
              rgbfillColor={0,0,255})),
          Polygon(points=[40,30; 40,-30; 100,0; 40,30], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=7,
              rgbfillColor={255,255,255})),
          Polygon(points=[0,50; 0,-50; -48,-74; -48,74; 0,50], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=7,
              rgbfillColor={255,255,255}))),
        DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Discrete Input Port</b></font>
<br/>
<br/>
The discrete input port accepts \"DEVS\" signals consisting of a real-valued vector of size three (signal[3]) and a Boolean variable (event).
</html>"));
      input Real signal[3];
      input Boolean event;
    end DiscreteInPort;

    connector DiscreteOutPort "DEVS output connector"
      annotation (
        uses(Modelica(version="1.6")),
        Diagram,
        Icon(Polygon(points=[-100,100; 100,0; -100,-100; -100,100], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=3,
              rgbfillColor={0,0,255})),
          Polygon(points=[40,30; 40,-30; 100,0; 40,30], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=7,
              rgbfillColor={255,255,255})),
          Polygon(points=[0,50; 0,-50; -48,-74; -48,74; 0,50], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=7,
              rgbfillColor={255,255,255}))),
        DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Discrete Output Port</b></font>
<br/>
<br/>
The discrete output port emits \"DEVS\" signals consisting of a real-valued vector of size three (signal[3]) and a Boolean variable (event).
</html>"));
      output Real signal[3];
      output Boolean event;
    end DiscreteOutPort;

    connector DiscreteInPortInterpolator
      "DEVS input connector for the Interpolator block"
      annotation (
        uses(Modelica(version="1.6")),
        Diagram,
        Icon(Polygon(points=[-100,100; 100,0; -100,-100; -100,100], style(
              color=1,
              rgbcolor={255,0,0},
              fillColor=1,
              rgbfillColor={255,0,0})),
          Polygon(points=[40,30; 40,-30; 100,0; 40,30], style(
              color=1,
              rgbcolor={255,0,0},
              fillColor=7,
              rgbfillColor={255,255,255})),
          Polygon(points=[0,50; 0,-50; -48,-74; -48,74; 0,50], style(
              color=1,
              rgbcolor={255,0,0},
              fillColor=7,
              rgbfillColor={255,255,255}))),
        DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Discrete Input Port for the Interpolator</b></font>
<br/>
<br/>
The discrete input port for the Interpolator block accepts \"DEVS\" signals consisting of a real-valued vector of size four (signal[4]) and a Boolean variable (event).
</html>"));
      input Real signal[4];
      input Boolean event;
    end DiscreteInPortInterpolator;

    connector DiscreteOutPortInterpolator
      "DEVS output connector, to be connected to an Interpolator."
      annotation (
        uses(Modelica(version="1.6")),
        Diagram,
        Icon(Polygon(points=[-100,100; 100,0; -100,-100; -100,100], style(
              color=1,
              rgbcolor={255,0,0},
              fillColor=1,
              rgbfillColor={255,0,0})),
          Polygon(points=[40,30; 40,-30; 100,0; 40,30], style(
              color=1,
              rgbcolor={255,0,0},
              fillColor=7,
              rgbfillColor={255,255,255})),
          Polygon(points=[0,50; 0,-50; -48,-74; -48,74; 0,50], style(
              color=1,
              rgbcolor={255,0,0},
              fillColor=7,
              rgbfillColor={255,255,255}))),
        DymolaStoredErrors,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Discrete Output Port for the Interpolator</b></font>
<br/>
<br/>
The discrete output port for the Interpolator block emits \"DEVS\" signals consisting of a real-valued vector of size four (signal[4]) and a Boolean variable (event).
<br/>
<br/>
Only the Integrator block uses this type of connector.
</html>"));
      output Real signal[4];
      output Boolean event;
    end DiscreteOutPortInterpolator;

    partial block BlockIcon "Basic graphical layout of DEVS blocks"
      annotation (
        Coordsys(extent=[-100, -100; 100, 100]),
        Window(
          x=0,
          y=0,
          width=0.6,
          height=0.6),
        Icon(Rectangle(extent=[-100, -100; 100, 100], style(
            color=74,
            rgbcolor={0,0,127},
            fillColor=7,
            rgbfillColor={255,255,255})),
                               Text(extent=[-150, 150; 150, 110], string=
                "%name")),
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Block Icon</b></font>
<br/>
<br/>
Draws the border line of ModelicaDEVS blocks. It is inherited by almost every other block.
</html>"));
    equation

    end BlockIcon;

    partial block DSource "DEVS source block"
      extends ModelicaDEVS.Templates.BlockIcon;
      parameter Integer method=world.qss "Use QSS1, QSS2 or QSS3";
      outer ModelicaDEVS.Miscellaneous.worldModel world;

      ModelicaDEVS.Templates.DiscreteOutPort outPort               annotation (
          extent=[100,-20; 140,20]);
    protected
      output Real yVal[3];
      output Boolean yEvent;

      annotation (Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]), Window(
          x=0.32,
          y=0.07,
          width=0.6,
          height=0.6),
        Icon,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Discrete Source</b></font>
<br/>
<br/>
This type of block is used for the most part of the ModelicaDEVS source blocks (except for the SamplerLevel, SamplerTime and SamplerTrigger which are of the type continuous-discrete).
</html>"));

    equation
      outPort.signal[1] = yVal[1];
      outPort.signal[2] = yVal[2];
      outPort.signal[3] = yVal[3];
      outPort.event = yEvent;

    end DSource;

    partial block CDBlock
      "Continuous single input - discrete single output block"
      extends ModelicaDEVS.Templates.BlockIcon;
      parameter Integer method=world.qss "Use QSS1, QSS2 or QSS3";
      outer ModelicaDEVS.Miscellaneous.worldModel world;
      Modelica.Blocks.Interfaces.RealInput inPort               annotation (
          extent=[-140, -20; -100, 20]);
      ModelicaDEVS.Templates.DiscreteOutPort outPort               annotation (
          extent=[100,-20; 140,20]);

      output Real yVal[3];
      output Boolean yEvent;
    protected
      Real u=inPort;
      annotation (Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]), Window(
          x=0.32,
          y=0.07,
          width=0.6,
          height=0.6),
        Icon,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Continuous-Discrete Block</b></font>
<br/>
<br/>
Continuous-discrete blocks have a real-type input port, connectable to the output ports of components in the Modelica/Blocks package, and a discrete DEVS output port, connectable to DEVS input ports.
<br/>
<br/>
Due to the different types of their input/output ports, the continuous-discrete blocks are used to connect non-DEVS blocks to DEVS blocks (SamplerLevel and SamplerTime)

\\\\
The CDBlockSpecial is a partial model similar to the CDBlock, but with an additional input port -- it is only used for the SamplerTrigger block (see Section \\ref{sec:samplerTrigger}).
</html>"));

    equation
      outPort.signal[1] = yVal[1];
      outPort.signal[2] = yVal[2];
      outPort.signal[3] = yVal[3];
      outPort.event = yEvent;

    end CDBlock;

    partial block CDBlockSpecial
      "Continuous single input - discrete single output block with an additional discrete input"
      extends ModelicaDEVS.Templates.BlockIcon;
      parameter Integer method=world.qss "Use QSS1, QSS2 or QSS3";
      outer ModelicaDEVS.Miscellaneous.worldModel world;
      Modelica.Blocks.Interfaces.RealInput inPort               annotation (
          extent=[-140, -20; -100, 20]);
      ModelicaDEVS.Templates.DiscreteOutPort outPort               annotation (
          extent=[100,-20; 140,20]);
      ModelicaDEVS.Templates.DiscreteInPort DiscreteInPort
        annotation (extent=[-20,-140; 20,-100], rotation=90);

      output Real yVal[3];
      output Boolean yEvent;
    protected
      Real u=inPort;
      Boolean uEvent=DiscreteInPort.event;
      annotation (Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]), Window(
          x=0.32,
          y=0.07,
          width=0.6,
          height=0.6),
        Icon,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Continuous-Discrete Special Block</b></font>
<br/>
<br/>
Continuous-discrete blocks have a real-type input port, connectable to the output ports of components in the Modelica/Blocks package, and a discrete DEVS output port, connectable to DEVS input ports.
<br/>
<br/>
Due to the different types of their input/output ports, the continuous-discrete blocks are used to connect non-DEVS blocks to DEVS blocks (SamplerLevel and SamplerTime)
<br/>
<br/>
The CDBlockSpecial is a partial model similar to the CDBlock, but with an additional input port - it is only used for the SamplerTrigger block.
</html>"));

    equation
      outPort.signal[1] = yVal[1];
      outPort.signal[2] = yVal[2];
      outPort.signal[3] = yVal[3];
      outPort.event = yEvent;

    end CDBlockSpecial;

    partial block DDBlock
      "Discrete single input - discrete single output block"
      extends ModelicaDEVS.Templates.BlockIcon;
      parameter Integer method=world.qss "Use QSS1, QSS2 or QSS3";
      outer ModelicaDEVS.Miscellaneous.worldModel world;

      ModelicaDEVS.Templates.DiscreteInPort inPort              annotation (
          extent=[-140,-20; -100,20]);
      ModelicaDEVS.Templates.DiscreteOutPort outPort               annotation (
          extent=[100,-20; 140,20]);

      output Real yVal[3];
      output Boolean yEvent;
    protected
      Real uVal[3];
      Boolean uEvent;
      annotation (Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]), Window(
          x=0.32,
          y=0.07,
          width=0.6,
          height=0.6),
        Icon,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Discrete-Discrete Block</b></font>
<br/>
<br/>
Discrete-discrete blocks are used for pure DEVS blocks that take and generate DEVS signals only.
</html>"));

    equation
      uVal[1]=inPort.signal[1];
      uVal[2]=inPort.signal[2];
      uVal[3]=inPort.signal[3];
      uEvent=inPort.event;

      outPort.signal[1] = yVal[1];
      outPort.signal[2] = yVal[2];
      outPort.signal[3] = yVal[3];
      outPort.event = yEvent;
    end DDBlock;

    partial block DDBlockSpecial
      "Discrete single input - discrete single output block with an additional output port"
      extends ModelicaDEVS.Templates.BlockIcon;
      parameter Integer method=world.qss "Use QSS1, QSS2 or QSS3";
      outer ModelicaDEVS.Miscellaneous.worldModel world;

      ModelicaDEVS.Templates.DiscreteInPort inPort              annotation (
          extent=[-140,-20; -100,20]);
      ModelicaDEVS.Templates.DiscreteOutPort outPort               annotation (
          extent=[100,-20; 140,20]);
      ModelicaDEVS.Templates.DiscreteOutPortInterpolator outPortInterpolator
                                                                   annotation (
          extent=[-20,-140; 20,-100], rotation=-90);

      output Real yVal[3];
      output Boolean yEvent;
      output Real yIntVal[4];
      output Boolean yIntEvent;
    protected
      Real uVal[3];
      Boolean uEvent;
      annotation (Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]), Window(
          x=0.32,
          y=0.07,
          width=0.6,
          height=0.6),
        Icon,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Discrete-Discrete Special Block</b></font>
<br/>
<br/>
Discrete-discrete blocks are used for pure DEVS blocks that take and generate DEVS signals only.
<br/>
<br/>
The DDBlockSpecial is a normal discrete-discrete block, but features an additional output port through which signals for the Interpolator can be sent.
</html>"));

    equation
      uVal[1]=inPort.signal[1];
      uVal[2]=inPort.signal[2];
      uVal[3]=inPort.signal[3];
      uEvent=inPort.event;

      outPort.signal[1] = yVal[1];
      outPort.signal[2] = yVal[2];
      outPort.signal[3] = yVal[3];
      outPort.event = yEvent;

      outPortInterpolator.signal[1] = yIntVal[1];
      outPortInterpolator.signal[2] = yIntVal[2];
      outPortInterpolator.signal[3] = yIntVal[3];
      outPortInterpolator.signal[4] = yIntVal[4];
      outPortInterpolator.event = yIntEvent;

    end DDBlockSpecial;

    partial block DoubleDDBlock
      "Discrete double input - discrete single output block"
      extends ModelicaDEVS.Templates.BlockIcon;
      parameter Integer method=world.qss "Use QSS1, QSS2 or QSS3";
      outer ModelicaDEVS.Miscellaneous.worldModel world;

      ModelicaDEVS.Templates.DiscreteInPort inPort1
                                     annotation (extent=[-140,20; -100,60]);
      ModelicaDEVS.Templates.DiscreteInPort inPort2
        annotation (extent=[-140,-60; -100,-20], rotation=0);
      ModelicaDEVS.Templates.DiscreteOutPort outPort               annotation (
          extent=[100,-20; 140,20]);

    protected
      Real uVal1[3];
      Real uVal2[3];
      Boolean uEvent1=inPort1.event;
      Boolean uEvent2=inPort2.event;
      output Real yVal[3];
      output Boolean yEvent;
      annotation (Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]), Window(
          x=0.32,
          y=0.07,
          width=0.6,
          height=0.6),
        Icon,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Double Discrete-Discrete Block</b></font>
<br/>
<br/>
Discrete-discrete blocks are used for pure DEVS blocks that take and generate DEVS signals only.
<br/>
<br/>
The DoubleDDBlock is used for DEVS models that have two input ports (e.g. the Add or the Multiplier block).
</html>"));

    equation
      uVal1[1]=inPort1.signal[1];
      uVal1[2]=inPort1.signal[2];
      uVal1[3]=inPort1.signal[3];

      uVal2[1]=inPort2.signal[1];
      uVal2[2]=inPort2.signal[2];
      uVal2[3]=inPort2.signal[3];

      outPort.signal[1] = yVal[1];
      outPort.signal[2] = yVal[2];
      outPort.signal[3] = yVal[3];
      outPort.event = yEvent;
    end DoubleDDBlock;

    partial block TripleDDBlock
      "Discrete triple input - discrete single output block"
      extends ModelicaDEVS.Templates.BlockIcon;
      parameter Integer method=world.qss "Use QSS1, QSS2 or QSS3";
      outer ModelicaDEVS.Miscellaneous.worldModel world;

      ModelicaDEVS.Templates.DiscreteInPort inPort1
                                     annotation (extent=[-140,40; -100,80]);
      ModelicaDEVS.Templates.DiscreteInPort inPort2
        annotation (extent=[-140,-20; -100,20],  rotation=0);
      ModelicaDEVS.Templates.DiscreteInPort inPort3
        annotation (extent=[-140,-80; -100,-40], rotation=0);
      ModelicaDEVS.Templates.DiscreteOutPort outPort               annotation (
          extent=[100,-20; 140,20]);

      output Real yVal[3];
      output Boolean yEvent;
    protected
      Real uVal1[3];
      Real uVal2[3];
      Real uVal3[3];
      Boolean uEvent1=inPort1.event;
      Boolean uEvent2=inPort2.event;
      Boolean uEvent3=inPort3.event;
      annotation (Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]), Window(
          x=0.32,
          y=0.07,
          width=0.6,
          height=0.6),
        Icon,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Triple Discrete-Discrete Block</b></font>
<br/>
<br/>
Discrete-discrete blocks are used for pure DEVS blocks that take and generate DEVS signals only.
<br/>
<br/>
The TripleDDBlock is used for the Switch block that has three input ports.
<br/>
<br/>
</html>"));

    equation
      uVal1[1]=inPort1.signal[1];
      uVal1[2]=inPort1.signal[2];
      uVal1[3]=inPort1.signal[3];

      uVal2[1]=inPort2.signal[1];
      uVal2[2]=inPort2.signal[2];
      uVal2[3]=inPort2.signal[3];

      uVal3[1]=inPort3.signal[1];
      uVal3[2]=inPort3.signal[2];
      uVal3[3]=inPort3.signal[3];

      outPort.signal[1] = yVal[1];
      outPort.signal[2] = yVal[2];
      outPort.signal[3] = yVal[3];
      outPort.event = yEvent;
    end TripleDDBlock;

    partial block DCBlock
      "Discrete single input - continuous single output block"
      extends ModelicaDEVS.Templates.BlockIcon;
      parameter Integer method=world.qss "Use QSS1, QSS2 or QSS3";
      outer ModelicaDEVS.Miscellaneous.worldModel world;

      ModelicaDEVS.Templates.DiscreteInPortInterpolator inPortInterpolator
                                                                annotation (
          extent=[-100,-20; -140,20], rotation=-180);
      Modelica.Blocks.Interfaces.RealOutput outPort                annotation (
          extent=[100,-20; 140,20]);

      output Real y;
    protected
      Real uVal[4]=inPortInterpolator.signal;
      Boolean uEvent=inPortInterpolator.event;

      annotation (Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]), Window(
          x=0.32,
          y=0.07,
          width=0.6,
          height=0.6),
        Icon,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Discrete-Continuous Block</b></font>
<br/>
<br/>
Only the Interpolator block is of this type, because it is the only component that takes DEVS signals - sent through the special (red) output port of other blocks - and generates real-type signals that can be processed by non-DEVS Dymola components.
<br/>
<br/>
The discrete-continous blocks are the counterpart of the continuous-discrete blocks.
</html>"));

    equation
      outPort= y;
    end DCBlock;

    partial block CCBlock "Continuous - continuous block"
      extends Modelica.Blocks.Interfaces.SISO
      annotation (Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]), Window(
          x=0.32,
          y=0.07,
          width=0.6,
          height=0.6),
        Icon,
        Diagram);
      parameter Integer qssMethod=3 "Use QSS1, QSS2 or QSS3";
      inner Miscellaneous.worldModel world(qss=qssMethod)
        annotation (extent=[-100,80; -80,100]);
      annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Continuous-Continuous Block</b></font>
<br/>
<br/>
This type of template is an extension of the Modelica.Blocks.Interfaces.SISO model and can be said to be a hull for a DEVS model that shall be inserted as a black box into a model consisting of blocks from the Modelica/Blocks library. Its only difference to the original block template is a) the WorldModel component it contains (remember that every model consisting of ModelicaDEVS blocks has to include the WorldModel), and b) the parameter qssMethod (it should be possible from the outside to set the parameter of the WorldModel and thereby influence the QSS mode of the model components. See lines 3+4 in the code snippet below for an illustration how the chosen QSS mode is propagated into the DEVS model).
<br/>
<br/>
The following declarations give a full description of the CCBlock:
<pre>
1 partial block CCBlock
2   extends Modelica.Blocks.Interfaces.SISO
3   parameter Integer qssMethod=3 \"Use QSS1, QSS2 or QSS3\";
4   inner Miscellaneous.worldModel world(qss=qssMethod);
5 end CCBlock;
</pre>
Note that if the DEVS model does not have to appear as a black box, the aforementioned CDBlock and DCBlock can be used to create an interface to the non-DEVS models.
</html>"));
    end CCBlock;

    partial model EEBlock "Electrical - electrical block"
      extends Modelica.Electrical.Analog.Interfaces.OnePort;
      parameter Integer qssMethod=3 "Use QSS1, QSS2 or QSS3";
      inner Miscellaneous.worldModel world(qss=qssMethod)
        annotation (extent=[-100,80; -80,100]);

    protected
      Modelica.Blocks.Interfaces.RealSignal inDEVS
        annotation (extent=[-92,-4; -72,4]);
      Modelica.Blocks.Interfaces.RealSignal outDEVS
        annotation (extent=[72,-4; 92,4]);

      annotation (Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]), Window(
          x=0.32,
          y=0.07,
          width=0.6,
          height=0.6),
        Icon,
        Diagram,
        Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Electrical-Electrical Block</b></font>
<br/>
<br/>
Electrical-electrical blocks are the analogon to CCBlocks - they are used to wrap electrical components built from ModelicaDEVS blocks.
<br/>
<br/>
From an electrical signal to a DEVS signal, two type conversions have to be made: the first one is from electrical to real-type, the second one from real-type to DEVS. Hence, between the electrical positive/negative pins and the first/last DEVS component, there is an additional RealSignal connector (see the following figure and the code snippet below).
<br/>
<br/>
<center><img src=\"../Images/EEBlockInner.png\" width=\"300\"></center>
<br/>
<br/>
<br/>

Note that the first/last DEVS block still has to be a transformation block that transforms the real-type signal to a genuine DEVS signal or vice-versa.
<br/>
The following code snippet gives the declarations of the EEBlock:
<pre>
1  partial model EEBlock
2    extends Modelica.Electrical.Analog.Interfaces.OnePort;
3    parameter Integer qssMethod=3 \"Use QSS1, QSS2 or QSS3\";
4    inner Miscellaneous.worldModel world(qss=qssMethod);
5
6  protected
7    Modelica.Blocks.Interfaces.RealSignal inDEVS ;
8    Modelica.Blocks.Interfaces.RealSignal outDEVS;
9
10 equation
11
12   inDEVS=p.i;
13   v=outDEVS;
14
15 end EEBlock;
</pre>
Due to the need of a electrical-to-real type conversion, virtual connections from the electrical pins to the real-type ports (inDEVS and outDEVS) have to be drawn. This is done by the two equations on line 12+13.
<br/>
<br/>
It is important to mention that this kind of electrical-electrical block assumes the current to be given and calculates the voltage. This has to be done because of Modelica's concept of equations instead of assignments that entails non-directed data flow, if not otherwise stated by declaring variables to be of type input or output. DEVS blocks, on the other hand, are always directed. Hence, assumptions about the flow of data have to be made when transforming from electical Modelica components to ModelicaDEVS blocks.
<br/>
<br/>
</html>"));

    equation
      inDEVS=p.i;
      v=outDEVS;

    end EEBlock;

    annotation (Documentation(info="<html>
<font color=\"#0000FF\" size=5><b>Templates</b></font>
<br/>
<br/>
This package contains the various connectors and the templates for the different block types.
</html>"));
  end Templates;

  package Examples "Examples"
    package DifferentialEquation "Differential Equation"
      model DEDymola "Standard Dymola simulation of a differential equation."
        output Real y;
        Real x(start=10);

      equation
        y=x;
        if time >= 1.76 then
          der(x)=-x+10;
        else
          der(x)=-x;
        end if;
        annotation (experiment(StopTime=10, Algorithm="Lsodar"),
            experimentSetupOutput,
          Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Dymola Differential Equation</b></font>
<br/>
<br/>
This example simulates the the following equation:
<br/>
<br/>
<center>dx/dt=-x + 10<b>s</b>(t-1.76)</center>
<br/>
where <b>s</b>() is the unit step function that returns 0 for a negative argument, and 1 for non-negative argument.
<br/>
<br/>
<br/>

<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
There is only a single output variable, y, that gives the analytical trajectory of x.
</html>"));
      end DEDymola;

      model DEDEVS "ModelicaDEVS simulation of a differential equation."
        annotation (uses(Modelica(version="1.6")), Diagram(
            Text(
              extent=[-8,18; 14,14],
              style(color=10, rgbcolor={95,95,95}),
              string="dx/dt"),
            Text(
              extent=[30,16; 52,12],
              style(color=10, rgbcolor={95,95,95}),
              string="x"),
            Text(
              extent=[-70,26; -42,22],
              style(color=10, rgbcolor={95,95,95}),
              string="10 if t>=1.76"),
            Text(
              extent=[-72,20; -50,16],
              style(color=10, rgbcolor={95,95,95}),
              string="0 else"),
            Text(
              extent=[-42,20; -20,16],
              style(color=10, rgbcolor={95,95,95}),
              string="+"),
            Text(
              extent=[-42,4; -20,0],
              style(color=10, rgbcolor={95,95,95}),
              string="-")),
          experiment(StopTime=10, Algorithm="Lsodar"),
          experimentSetupOutput(
            states=false,
            derivatives=false,
            inputs=false,
            auxiliaries=false),
          Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>ModelicaDEVS Differential Equation</b></font>
<br/>
<br/>
This example simulates the the following equation:
<br/>
<br/>
<center>dx/dt=-x + 10<b>s</b>(t-1.76)</center>
<br/>
where <b>s</b>() is the unit step function that returns 0 for a negative argument, and 1 for non-negative argument.
<br/>
<br/>
Note that the above equation had to be transformed into a block diagram, in order to model it by means of the ModelicaDEVS blocks.
<br/>
<br/>
<br/>
<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
The two output variables TrajectoryDEVS and Trajectory give the original DEVS output (the first entry of the Integrator signal) and the interpolated version.
</html>"));
        output Real Trajectory;
        output Real TrajectoryDEVS;
        FunctionBlocks.Add Add1(c0=1, c1=-1)
                                 annotation (extent=[-28,0; -8,20]);
        SourceBlocks.Step Step1(a=10, ts=1.76)
          annotation (extent=[-94,4; -74,24]);

        SinkBlocks.Interpolator Interpolator1    annotation (extent=[62,0; 82,
              20]);
        FunctionBlocks.Integrator Integrator1(startX=10, quantum=1)
          annotation (extent=[14,0; 34,20]);
        inner ModelicaDEVS.Miscellaneous.worldModel world(qss=3)
                               annotation (extent=[-100,80; -80,100]);

      equation
        Trajectory=Interpolator1.outPort;
        TrajectoryDEVS=Integrator1.outPort.signal[1];
        connect(Step1.outPort, Add1.inPort1) annotation (points=[-72,14; -30,14],
                                 style(color=3, rgbcolor={0,0,255}));
        connect(Add1.outPort, Integrator1.inPort)
          annotation (points=[-6,10; 12,10],   style(color=3, rgbcolor={0,0,255}));
        connect(Integrator1.outPortInterpolator, Interpolator1.
          inPortInterpolator) annotation (points=[24,-2; 24,-16; 54,-16; 54,10;
              60,10],
            style(color=1, rgbcolor={255,0,0}));
        connect(Integrator1.outPort, Add1.inPort2) annotation (points=[36,10;
              46,10; 46,-14; -56,-14; -56,6; -30,6],
                                              style(color=3, rgbcolor={0,0,255}));
      end DEDEVS;

      annotation (Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Differential Equation</b></font>
<br/>
<br/>
The two models in this package simulate a simple differential equation. This example is taken from [Cellier05], Chapter 11.
<br/>
<br/>
The model \"DEDEVS\" simulates the mentioned continuous system by means of the ModelicaDEVS blocks, while \"DEDymola\" is a model that simply contains the differential equation.
</html>"));
    end DifferentialEquation;

    package Electrical "Electrical Examples"

      package AdditionalBlocks "Additional blocks for the electrical examples"
        block SamplerTimeNumerical
          "Samples a signal at periodical time instant, computes the derivatives numerically."
          extends ModelicaDEVS.Templates.CDBlock;

          parameter Real period= 1e-6 "Period";
          parameter Real start= 0 "Start Time";
          parameter Real d= 1e-6
            "Delay value for the numerical differentiation.";
        protected
          Real du;
          Real d2u;

        equation
          when sample(start,period) then
            du = delay(pre(u),d);
            d2u= delay(pre(u),2*d);
            yVal[1]= pre(u);
            yVal[2]= if method>1 then (pre(u)-du)/d else 0;
            yVal[3]= if method>2 then (pre(u)-2*du+d2u)/(d*d) else 0;
          end when;
          yEvent=sample(start,period);
          annotation (Icon(
              Line(points=[-70,84; -70,-86], style(color=0, rgbcolor={0,0,0})),
              Line(points=[-92,-50; -90,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
              Line(points=[-70,-14; -30,-14; -30,20; 10,20; 10,66; 66,66],   style(
                    color=3, rgbcolor={0,0,255})),
              Line(points=[-30,-14; -30,-50], style(
                  color=71,
                  rgbcolor={85,170,255},
                  pattern=3)),
              Line(points=[10,20; 10,-50], style(
                  color=71,
                  rgbcolor={85,170,255},
                  pattern=3))),                     DymolaStoredErrors,
            Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>The SamplerTimeNumerical Block</b></font>
<br/>
<br/>
<font color=\"#FF0000\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>period</b></td>
<td>length of the sampling intervals</td>
</tr>
<tr>
<td><b>start</b></td>
<td>start time of the sampling period</td>
</tr>
<tr>
<td><b>d</b></td>
<td>delay value for the numerical differentiation.</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#FF0000\"><b>Description:</b></font>
<br/>
<br/>
This block is derived from the conventional <a href=\"Modelica://ModelicaDEVS.SourceBlocks.SamplerTime\"> SamplerTime</a> block, only that instead of using the der() operator to compute the derivatives (or more precisely the coefficients of the Taylor series up to second order) for the second and third output value, it uses the concept of difference equations:
<br/>
<br/>
<center>dx/dt=(x(t)-x(t-h))/h</center>
<br/>
where h is represented by the value of d, and the value x(t-h) is obtained by using the Modelica delay() function:
<br/>
<br/>
<center>delay(x,d)</center>
<br/>
<br/>
For details on the generated output events, see the original <a href=\"Modelica://ModelicaDEVS.SourceBlocks.SamplerTime\"> SamplerTime</a> block.
</html>"));
        end SamplerTimeNumerical;

        model CapacitorDEVSNumerical
          "Capacitor built from DEVS blocks, uses numerical differentiation."
          extends ModelicaDEVS.Templates.EEBlock;
          parameter Modelica.SIunits.Capacitance C=1 "Capacitance";
          parameter Real period=1e-6 "Sampling period";
          parameter Real start=0 "Start time";
          parameter Real d= 1e-6
            "Delay value for the numerical differentiation.";                                                                                                    //inherits Capacitance
          FunctionBlocks.Integrator Integrator1 annotation (extent=[6,-10; 26,10]);
                   annotation (Diagram, Icon(
              Rectangle(extent=[-40,92; -20,-92], style(
                  color=3,
                  rgbcolor={0,0,255},
                  gradient=1,
                  fillColor=58,
                  rgbfillColor={0,127,0})),
              Rectangle(extent=[20,92; 40,-92], style(
                  color=3,
                  rgbcolor={0,0,255},
                  gradient=1,
                  fillColor=58,
                  rgbfillColor={0,127,0})),
              Line(points=[-90,0; -40,0], style(
                  color=3,
                  rgbcolor={0,0,255},
                  gradient=1,
                  fillColor=58,
                  rgbfillColor={0,127,0})),
              Line(points=[40,0; 90,0], style(
                  color=3,
                  rgbcolor={0,0,255},
                  gradient=1,
                  fillColor=58,
                  rgbfillColor={0,127,0}))),
            Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>The CapacitorDEVSNumerical Block</b></font>
<br/>
<br/>
<font color=\"#FF0000\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>period</b></td>
<td>length of the sampling intervals</td>
</tr>
<tr>
<td><b>start</b></td>
<td>start time of the sampling period</td>
</tr>
<tr>
<td><b>d</b></td>
<td>delay value for the numerical differentiation.</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#FF0000\"><b>Description:</b></font>
<br/>
<br/>
The CapacitorDEVSNumerical block is an almost exact copy of the <a href=\"Modelica://ModelicaDEVS.Examples.Electrical.AdditionalBlocks.CapacitorDEVS\">
CapacitorDEVS</a> block, only that the normal SamplerTime is replaced by a SamplerTime<b>Numerical</b> block. The SamplerTimeNumerical block avoids the problem caused by the der() (see description of the CapacitorDEVS block) operator by means of the delay() function that is used to differentiate numerically (concept of difference equations) instead of analytically. This means that instead of the first and second derivatives of the input signal, the SamplerTimeNumerical returns a numerical approximation.
</html>"));

          SinkBlocks.Interpolator Interpolator1 annotation (extent=[42,-10; 62,10]);
          FunctionBlocks.Gain Gain1(g=1/C) annotation (extent=[-28,-10; -8,10]);

          SamplerTimeNumerical SamplerTimeNumerical1(period=period,d=d,start=start)
            annotation (extent=[-62,-10; -42,10]);
        equation
          connect(Gain1.outPort, Integrator1.inPort)
            annotation (points=[-6,0; 4,0],   style(color=3, rgbcolor={0,0,255}));
          connect(Integrator1.outPortInterpolator, Interpolator1.inPortInterpolator)
            annotation (points=[16,-12; 16,-16; 34,-16; 34,0; 40,0],
                                                                   style(color=1,
                rgbcolor={255,0,0}));
          connect(Interpolator1.outPort, outDEVS)
            annotation (points=[64,0; 82,0], style(color=74, rgbcolor={0,0,127}));
          connect(SamplerTimeNumerical1.outPort, Gain1.inPort)
                                                       annotation (points=[-40,0;
                -30,0], style(color=3, rgbcolor={0,0,255}));
          connect(SamplerTimeNumerical1.inPort, inDEVS)
                                                annotation (points=[-64,0; -82,0],
              style(color=74, rgbcolor={0,0,127}));
        end CapacitorDEVSNumerical;

        model CapacitorDEVS "Capacitor built from DEVS blocks"
          extends ModelicaDEVS.Templates.EEBlock;
          parameter Modelica.SIunits.Capacitance C=1 "Capacitance";
          parameter Real period=1e-6 "Sampling period";
          FunctionBlocks.Integrator Integrator1 annotation (extent=[6,-10; 26,10]);
                   annotation (Diagram, Icon(
              Rectangle(extent=[-40,92; -20,-92], style(
                  color=3,
                  rgbcolor={0,0,255},
                  gradient=1,
                  fillColor=58,
                  rgbfillColor={0,127,0})),
              Rectangle(extent=[20,92; 40,-92], style(
                  color=3,
                  rgbcolor={0,0,255},
                  gradient=1,
                  fillColor=58,
                  rgbfillColor={0,127,0})),
              Line(points=[-90,0; -40,0], style(
                  color=3,
                  rgbcolor={0,0,255},
                  gradient=1,
                  fillColor=58,
                  rgbfillColor={0,127,0})),
              Line(points=[40,0; 90,0], style(
                  color=3,
                  rgbcolor={0,0,255},
                  gradient=1,
                  fillColor=58,
                  rgbfillColor={0,127,0}))),
            Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>The CapacitorDEVS Block</b></font>
<br/>
<br/>
<font color=\"#FF0000\"><b>Parameters:</b></font>
<table border=0 cellspacing=0 cellpadding=1>
<tr>
<td><b>period</b></td>
<td>length of the sampling intervals</td>
</tr>
<tr>
<td><b>start</b></td>
<td>start time of the sampling period</td>
</tr>
</table>
<br/>
<br/>
<font color=\"#FF0000\"><b>Description:</b></font>
<br/>
<br/>
The figure below illustrates the implementation of the ModelicaDEVS capacitor. In order to be connectable to blocks from the electrical library of Modelica, it has to extend the EEBlock of the ModelicaDEVS library. This block looks like the TwoPin block interface provided by Dymola on its outside, but internally performs a type conversion of the input and output signals: the two blocks inDEVS and outDEVS are used to transform the signals from the electrical pins to signals of type real and vice-versa. The second type conversion is done by means of the SamplerTime and the Interpolator blocks that act as interfaces to non-DEVS components with real-valued input/output signals.
<br/>
Note that it would have been more appropriate to use the SamplerLevel block, because the scope of DEVS integration is to by-pass the time discretisation. However, as we will see later, it was necessary to program a numerical version of the sampler block, in order to enable mixed simulations. Unfortunately, the numerical version of the SamplerLevel block led to aborted simulations due to \"inconsistent restarting conditions\". With a numerical version of the SamplerTime block on the other hand, the simulation could be performed without encountering any difficulties. Hence for the sake of consistency, it was decided to only use time sampler blocks instead of a SamplerLevel for the CapacitorDEVS block and a SamplerTimeNumerical for the CapacitorDEVSNumerical block.
<br/>
<br/>
<center><img src=\"../Images/CapacitorInner.png\" width=\"400\"></center>
<br/>
<br/>
<br/>
The full textual description of the ModelicaDEVS capacitor is given below:
<pre>
1  model CapacitorDEVS
2    extends ModelicaDEVS.Templates.EEBlock;
3    parameter Modelica.SIunits.Capacitance C=1 \"Capacitance\";
4    parameter Real period=1e-6 \"Sampling period\";
5
6    SourceBlocks.SamplerTime SamplerTime1(period=period);
7    FunctionBlocks.Integrator Integrator1;
8    SinkBlocks.Interpolator Interpolator1;
9    FunctionBlocks.Gain Gain1(g=1/C);
10
11 equation
12   connect(SamplerTime1.outPort, Gain1.inPort);
13   connect(Gain1.outPort, Integrator1.inPort);
14   connect(Integrator1.outPortInterpolator, Interpolator1.inPortInterpolator);
15   connect(inDEVS, SamplerTime1.inPort);
16   connect(Interpolator1.outPort, outDEVS);
17 end CapacitorDEVS;
</pre>

The SamplerTime block (line 6) samples the signal of the electrical current at a period specified by the parameter sampling (line 4), and the Gain block (line 9) multiplies the incoming signal by the value of 1/C, where C is again specified by a parameter (line 3). Taken as a whole, the ModelicaDEVS blocks constitute nothing else than the well known capacitor formula
<center> i=C*dv/dt </center>
in an algebraically modified version:
<center> v=1/C*integral(i) </center>
<br/>

Unfortunately, the CapacitorDEVS block exhibits two problems - one solvable, the other not yet:
<ul>
<li>
The electrical components do not assume a certain data flow direction since they are described by acausal equations (an acausal equation x=y is an equation in its literal sense, so it can be understood as x=y or y=x. A causal equation on the other hand assigns a variable a certain value, so the meaning of x=y is actually x:=y. Note that causal equation are also often called assignments. The data flow of ModelicaDEVS components on the other hand is directed, since DEVS components feature input and output ports instead of electrical bi-directional pins. This means that our ModelicaDEVS capacitor has to turn acausal equations into causal ones: it assumes it is given the current i, and hence it computes the voltage v. Unfortunately, such a capacitor would not work anymore if we were to connect it to a voltage source instead of a current generator.
</li>
<br/>
<br/>
<li>
An even more severe problem (that could not be solved yet) is caused by the SamplerTime block applying the der() operator to the signal that it receives through its input port (lines 2 and 8 in the code snipped below):
<pre>
1 equation
2   derivative=der(u); //used to produce der(der(u))
3   yEvent= sample(start,period);
5   when sample(start,period) then
6     yVal[1]= u;
7     yVal[2]= if method>1 then derivative else 0;
8     yVal[3]= if method>2 then der(derivative) else 0;
9   end when;
</pre>

Given that the input of the SamplerTime block depends on the output of the Interpolator in the DEVS capacitor, Dymola would have to differentiate the output of the Interpolator, which unfortunately it is not able to, and hence aborts the simulation with a \"Failed to differentiate the equation in order to reduce the DAE index.\" error message. <br/>
An attempt to solve this problem was made using Dymola's \"User specified Derivatives\" feature described in the Dymola Handbook [Dymola]: functions for the first and second derivatives have been inserted into the Interpolator, but due to unknown reasons, this did not solve the issue neither.
<br/>
The <a href=\"Modelica://ModelicaDEVS.Examples.Electrical.AdditionalBlocks.CapacitorDEVSNumerical\">
CapacitorDEVSNumerical</a> block shows how this problem could be by-passed using a numerical solution.
<br/>
<br/>
</html>"));

          SinkBlocks.Interpolator Interpolator1 annotation (extent=[42,-10; 62,10]);
          FunctionBlocks.Gain Gain1(g=1/C) annotation (extent=[-28,-10; -8,10]);

          SourceBlocks.SamplerTime SamplerTime1(period=period,start=start)
            annotation (extent=[-62,-10; -42,10]);

        equation
          connect(Gain1.outPort, Integrator1.inPort)
            annotation (points=[-6,0; 4,0],   style(color=3, rgbcolor={0,0,255}));
          connect(Integrator1.outPortInterpolator, Interpolator1.inPortInterpolator)
            annotation (points=[16,-12; 16,-16; 34,-16; 34,0; 40,0],
                                                                   style(color=1,
                rgbcolor={255,0,0}));
          connect(Interpolator1.outPort, outDEVS)
            annotation (points=[64,0; 82,0], style(color=74, rgbcolor={0,0,127}));
          connect(SamplerTime1.outPort, Gain1.inPort)  annotation (points=[-40,0;
                -30,0], style(color=3, rgbcolor={0,0,255}));
          connect(SamplerTime1.inPort, inDEVS)  annotation (points=[-64,0; -82,0],
              style(color=74, rgbcolor={0,0,127}));
        end CapacitorDEVS;
        annotation (Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Additional Blocks</b></font>
<br/>
<br/>
This package contains three blocks (SamplerTimeNumerical, CapacitorDEVS and CapacitorDEVSNumerical) that are used for the examples located in the packages SimpleCircuit and FlybackConverter.
</html>"));
      end AdditionalBlocks;

      package SimpleCircuit "Simple Circuit Example"
        model SimpleCircuitDymola
          "Standard Dymola simulation of a simple circuit."
          annotation (Diagram,
            experiment(StopTime=3, Algorithm="Lsodar"),
            experimentSetupOutput(
              states=false,
              derivatives=false,
              inputs=false,
              auxiliaries=false),
            Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Dymola Simple Circuit</b></font>
<br/>
<br/>
The circuit used for this example consists of merely a current generator, a capacitor and a load. Since the models was only used for testing whether it is possible to replace a Dymola component by ModelicaDEVS blocks, the parameters to the components in the model are set randomly and have no actual meaning.
<br/>
<br/>
<br/>

<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
The two output variables, Resistor_i and Resistor_u, give the current through and the voltage across the load resistance.
</html>"));
          output Real Resistor_i;
          output Real Resistor_u;
          Modelica.Electrical.Analog.Basic.Ground Ground1
            annotation (extent=[30,-6; 10,-26],  rotation=180);
          Modelica.Electrical.Analog.Sources.ConstantCurrent ConstantCurrent1(I=20)
            annotation (extent=[-40,-30; -20,-10],
                                                rotation=0);
          Modelica.Electrical.Analog.Basic.Resistor Resistor1(R=5)
            annotation (extent=[-40,30; -20,50],
                                              rotation=0);
          Modelica.Electrical.Analog.Basic.Capacitor Capacitor1(C=2)
            annotation (extent=[-40,0; -20,20],
                                              rotation=0);

        equation
          Resistor_i=Resistor1.v;
          Resistor_u=Resistor1.i;
          connect(Ground1.p, ConstantCurrent1.n)
            annotation (points=[20,-6; 20,0; 0,0; 0,-20; -20,-20],
                                                 style(color=3, rgbcolor={0,0,255}));
          connect(ConstantCurrent1.p, Capacitor1.p) annotation (points=[-40,-20; -60,
                -20; -60,10; -40,10],
                             style(color=3, rgbcolor={0,0,255}));
          connect(Capacitor1.p, Resistor1.p) annotation (points=[-40,10; -60,10; -60,40;
                -40,40],
                     style(color=3, rgbcolor={0,0,255}));
          connect(Capacitor1.n, Resistor1.n) annotation (points=[-20,10; 0,10; 0,40;
                -20,40],
              style(color=3, rgbcolor={0,0,255}));
          connect(Capacitor1.n, ConstantCurrent1.n)
            annotation (points=[-20,10; 0,10; 0,-20; -20,-20],
                                                  style(color=3, rgbcolor={0,0,255}));
        end SimpleCircuitDymola;

        model SimpleCircuitMixed
          "ModelicaDEVS/standard Dymola mixed simulation of a simple circuit."
          annotation (Diagram,
            experiment(StopTime=3, Algorithm="Lsodar"),
            experimentSetupOutput(
              states=false,
              derivatives=false,
              inputs=false,
              auxiliaries=false),
            Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Dymola/ModelicaDEVS Simple Circuit</b></font>
<br/>
<br/>
The circuit used for this example consists of merely a current generator, a capacitor and a load. Since the models was only used for testing whether it is possible to replace a Dymola component by ModelicaDEVS blocks, the parameters to the components in the model have no distinct meaning. For comparison purposes However, they are set equal to the parameters in the SimpleCircuitDymola model.
<br/>
<br/>
Remark: this model does not work yet, due to the differentiation problem described in the documentation section of the <a href=\"Modelica://ModelicaDEVS.Examples.Electrical.AdditionalBlocks.CapacitorDEVS\">
CapacitorDEVS</a> block.
<br/>
<br/>
<br/>

<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
The two output variables, Resistor_i and Resistor_u, give the current through and the voltage across the load resistance.
</html>"));
          output Real Resistor_i;
          output Real Resistor_u;
          Modelica.Electrical.Analog.Basic.Ground Ground1
            annotation (extent=[50,-6; 70,14], rotation=0);
          Modelica.Electrical.Analog.Sources.ConstantCurrent ConstantCurrent1(I=20)
            annotation (extent=[0,-10; 20,10],  rotation=0);
          Modelica.Electrical.Analog.Basic.Resistor Resistor1(R=5)
            annotation (extent=[0,50; 20,70], rotation=0);
          ModelicaDEVS.Examples.Electrical.AdditionalBlocks.CapacitorDEVS
            Capacitor1(                                                              C=2)
                                      annotation (extent=[0,20; 20,40], rotation=0);

        equation
          Resistor_i=Resistor1.v;
          Resistor_u=Resistor1.i;
          connect(Ground1.p, ConstantCurrent1.n)
            annotation (points=[60,14; 60,20; 40,20; 40,0; 20,0],
                                                 style(color=3, rgbcolor={0,0,255}));
          connect(ConstantCurrent1.n, Capacitor1.n) annotation (points=[20,0; 40,0; 40,30;
                20,30], style(color=3, rgbcolor={0,0,255}));
          connect(Resistor1.n, Capacitor1.n) annotation (points=[20,60; 40,60; 40,30;
                20,30], style(color=3, rgbcolor={0,0,255}));
          connect(Resistor1.p, Capacitor1.p) annotation (points=[0,60; -20,60; -20,30;
                0,30], style(color=3, rgbcolor={0,0,255}));
          connect(Capacitor1.p, ConstantCurrent1.p) annotation (points=[0,30; -20,30;
                -20,0; 0,0], style(color=3, rgbcolor={0,0,255}));
        end SimpleCircuitMixed;

        model SimpleCircuitMixedNumerical
          "ModelicaDEVS/standard Dymola mixed (numerically approximated) simulation of a simple circuit."
          annotation (Diagram,
            experiment(StopTime=3, Algorithm="Lsodar"),
            experimentSetupOutput(
              states=false,
              derivatives=false,
              inputs=false,
              auxiliaries=false),
            Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Dymola/ModelicaDEVS Numerically Approximated Simple Circuit</b></font>
<br/>
<br/>
The circuit used for this example consists of merely a current generator, a capacitor and a load. Since the models was only used for testing whether it is possible to replace a Dymola component by ModelicaDEVS blocks, the parameters to the components in the model have no distinct meaning. For comparison purposes However, they are set equal to the parameters in the SimpleCircuitDymola model.
<br/>
<br/>
Contrary to the SimpleCircuitMixed example, this model uses the CapacitorDEVSNumerical block instead of the CapacitorDEVS block, thereby avoiding analytical differentiation.
<br/>
<br/>
<br/>

<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
The two output variables, Resistor_i and Resistor_u, give the current through and the voltage across the load resistance.
</html>"));
          output Real Resistor_i;
          output Real Resistor_u;
          Modelica.Electrical.Analog.Basic.Ground Ground1
            annotation (extent=[50,-6; 70,14], rotation=0);
          Modelica.Electrical.Analog.Sources.ConstantCurrent ConstantCurrent1(I=20)
            annotation (extent=[0,-10; 20,10],  rotation=0);
          Modelica.Electrical.Analog.Basic.Resistor Resistor1(R=5)
            annotation (extent=[0,50; 20,70], rotation=0);
          ModelicaDEVS.Examples.Electrical.AdditionalBlocks.CapacitorDEVSNumerical
            Capacitor1(                                                                       C=2, period=1e-2)
                                      annotation (extent=[0,20; 20,40], rotation=0);

        equation
          Resistor_u=Resistor1.v;
          Resistor_i=Resistor1.i;
          connect(Ground1.p, ConstantCurrent1.n)
            annotation (points=[60,14; 60,20; 40,20; 40,0; 20,0],
                                                 style(color=3, rgbcolor={0,0,255}));
          connect(ConstantCurrent1.n, Capacitor1.n) annotation (points=[20,0; 40,0; 40,30;
                20,30], style(color=3, rgbcolor={0,0,255}));
          connect(Resistor1.n, Capacitor1.n) annotation (points=[20,60; 40,60; 40,30;
                20,30], style(color=3, rgbcolor={0,0,255}));
          connect(Resistor1.p, Capacitor1.p) annotation (points=[0,60; -20,60; -20,30;
                0,30], style(color=3, rgbcolor={0,0,255}));
          connect(Capacitor1.p, ConstantCurrent1.p) annotation (points=[0,30; -20,30;
                -20,0; 0,0], style(color=3, rgbcolor={0,0,255}));
        end SimpleCircuitMixedNumerical;
        annotation (Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Simple Circuit</b></font>
<br/>
<br/>
This example was used to carry out the first tests regarding the substitution of a standard Dymola electrical component (a capacitor, in our case) by ModelicaDEVS blocks.
<br/>
<br/>
The three different models simulate the same circuit, once with standard Dymola components, once in a mixed simulation with the capacitor replaced by the ModelicaDEVS capacitor, and once again with the capacitor replaced, but this time using numerical instead of analytical differentiation.
<br/>
Note that the second example (SimpleCircuitMixed) does not work due to the problem described along with the <a href=\"Modelica://ModelicaDEVS.Examples.Electrical.AdditionalBlocks.CapacitorDEVS\">
CapacitorDEVS</a> block.
</html>"));
      end SimpleCircuit;

      package FlybackConverter "Flyback Converter Example"
        model FlybackConverterDymola
          "Standard Dymola simulation of the flyback converter."
          output Real Inductor_i;
          output Real Resistor_u;
          Modelica.Electrical.Analog.Basic.Capacitor Capacitor1(C=22E-6)
            annotation (extent=[48,-30; 68,-50],
                                               rotation=90);
          Modelica.Electrical.Analog.Ideal.IdealDiode IdealDiode1(Vknee=0)
            annotation (extent=[20,-32; 40,-12]);
          Modelica.Electrical.Analog.Sources.ConstantVoltage ConstantVoltage1(V=40)
            annotation (extent=[-84,-32; -64,-52],
                                                 rotation=90);
          annotation (Diagram,
            experiment(StopTime=0.002, Algorithm="Lsodar"),
            experimentSetupOutput(
              states=false,
              derivatives=false,
              inputs=false,
              auxiliaries=false),
            Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Dymola Flyback Converter</b></font>
<br/>
<br/>
This model shows the flyback converter with a voltage source connected to the primary winding of the converter and a load to its secondary winding.
<br/>
<br/>
The flyback converter can be used to transform a given input voltage to a different output voltage. It belongs to the group of DC-DC converters.
<br/>
The operation of the flyback converter consists of two phases:
<ul>
<li>
Phase 1: When the switch is closed, the diode is locked and current flows through the inductor on the left side of the transformer (primary winding), setting up a magnetic field. The consumer load (a resistor in our case) is driven by the energy stored in the capacitor.
</li>
<li>
Phase 2: When the switch is opened, the voltage source is separated from the circuit. The magnetic field of the inductance is responsible for creating a current that flows through the diode now, since it cannot flow via the voltage source anymore. The inductor serves as a source of energy, which means that it charges the capacitor and runs the load.
<li>
</ul>
The two phases are repeated in high frequency (controlled by the boolean signal that is connected to the switch), thereby providing the load with an almost constant current.
<br/>
<br/>
The figure below shows the first two milliseconds of a simulation run of the flyback converter circuit. Additionally, it also shows a more detailed view (only 0.19 milliseconds) in order to illustrate the influence of the switch on the trajectory of the voltage/current at the load: when the switch (green) is closed, the resistor is driven by the capacitor, so the voltage (blue) and the current (red) at the resistor decreases slowly (phase 1) (note that given the fact that it is an Ideal<b>Closing</b>Switch, it is closed if the variable control equals 1). When the switch is open, it is the voltage source to power supply the resistor, so the resistor voltage/current increases (phase 2).
<br/>
<br/>
<center><img src=\"../Images/FlybackOutD.png\" width=\"500\"></center>
<br/>
<br/>


<br/>
<br/>
<center><img src=\"../Images/FlybackEquations.png\" width=\"500\"></center>
<br/>
<br/>
The converter circuit can be described by the following equations (consider the above figure for a definition of the variables):
<center>

U<sub>0</sub> = constant<br/>
0 = if open<sub>1</sub> then i<sub>0</sub> else u<sub>S</sub> <br/>
u<sub>L</sub> = L * di<sub>L</sub>/dt <br/>
i<sub>C</sub> = C * du<sub>R</sub>/dt> <br/>
u<sub>R</sub> = R * i<sub>R</sub> <br/>
0 = if open<sub>2</sub> then i<sub>D</sub> else u<sub>D</sub> <br/>
open<sub>2</sub> = u<sub>D</sub> &lt; 0 and i<sub>D</sub> &lt;= 0<br/>
u<sub>T</sub> = -u<sub>L</sub><br/>
i<sub>T</sub> = -i<sub>D</sub><br/>
i<sub>0</sub> = i<sub>L</sub>+i<sub>T</sub> <br/>
i<sub>D</sub> = i<sub>C</sub>+i<sub>R</sub> <br/>
u<sub>0</sub> = u<sub>S</sub>+i<sub>L</sub> <br/>
0 = u<sub>T</sub>+u<sub>D</sub>+u<sub>R</sub>
</center>
<br/>
<br/>
Note that these equations give an acausal description of the flyback converter, which is not what we will need to set up a flyback model in ModelicaDEVS or PowerDEVS. However, this issue is explained in more detail in the documentation section of the <a href=\"Modelica://ModelicaDEVS.Examples.Electrical.FlybackConverter.FlybackConverterDEVS\">
FlybackConverterDEVS</a> example.
<br/>
<br/>
<br/>

<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
The two output variables, Inductor_i and Resistor_u, give the current through the inductor and the voltage across the load resistance.
<br/>
<br/>
</html>"));
          Modelica.Electrical.Analog.Basic.Resistor Resistor1(R=5)
            annotation (extent=[96,-32; 76,-52],
                                               rotation=90);
          Modelica.Electrical.Analog.Basic.Inductor Inductor1(L=200E-6)
            annotation (extent=[-42,-32; -22,-52],
                                                 rotation=90);
          Modelica.Electrical.Analog.Ideal.IdealClosingSwitch
            IdealClosingSwitch1
            annotation (extent=[-64,-32; -44,-12]);
          Modelica.Electrical.Analog.Ideal.IdealTransformer Transformer1(n=-1)
            annotation (extent=[-12,-56; 6,-28]);
          Modelica.Blocks.Sources.BooleanPulse BooleanPulse1(                width=100/
                3, period=1.67E-5)
            annotation (extent=[-82,20; -62,40]);
          Modelica.Electrical.Analog.Basic.Ground Ground1
            annotation (extent=[-72,-86; -52,-66]);
          Modelica.Electrical.Analog.Basic.Ground Ground2
            annotation (extent=[64,-90; 84,-70]);

        equation
          Inductor_i=Inductor1.i;
          Resistor_u=Resistor1.v;
          connect(Transformer1.n2, Capacitor1.n) annotation (points=[6,-49; 6,-58; 58,
                -58; 58,-50], style(color=3, rgbcolor={0,0,255}));
          connect(ConstantVoltage1.p, IdealClosingSwitch1.p)
                                                         annotation (points=[-74,-32;
                -74,-22; -64,-22], style(color=3, rgbcolor={0,0,255}));
          connect(Transformer1.p2, IdealDiode1.p) annotation (points=[6,-35; 6,-22; 20,
                -22], style(color=3, rgbcolor={0,0,255}));
          connect(IdealDiode1.n, Capacitor1.p) annotation (points=[40,-22; 58,-22; 58,
                -30], style(color=3, rgbcolor={0,0,255}));
          connect(Resistor1.n, Capacitor1.n) annotation (points=[86,-52; 86,-58; 58,-58;
                58,-50], style(color=3, rgbcolor={0,0,255}));
          connect(Resistor1.p, Capacitor1.p) annotation (points=[86,-32; 86,-22; 58,-22;
                58,-30], style(color=3, rgbcolor={0,0,255}));
          connect(BooleanPulse1.y, IdealClosingSwitch1.control) annotation (points=[-61,30;
                -54,30; -54,-15],     style(color=5, rgbcolor={255,0,255}));
          connect(Ground1.p, ConstantVoltage1.n)
                                             annotation (points=[-62,-66; -62,-58; -74,
                -58; -74,-52], style(color=3, rgbcolor={0,0,255}));
          connect(Ground2.p, Resistor1.n) annotation (points=[74,-70; 74,-58; 86,-58;
                86,-52], style(color=3, rgbcolor={0,0,255}));
          connect(IdealClosingSwitch1.n, Inductor1.p) annotation (points=[-44,-22;
                -32,-22; -32,-32], style(color=3, rgbcolor={0,0,255}));
          connect(Inductor1.p, Transformer1.p1) annotation (points=[-32,-32; -32,
                -22; -12,-22; -12,-35], style(color=3, rgbcolor={0,0,255}));
          connect(Transformer1.n1, Inductor1.n) annotation (points=[-12,-49; -12,
                -58; -32,-58; -32,-52], style(color=3, rgbcolor={0,0,255}));
          connect(Inductor1.n, ConstantVoltage1.n) annotation (points=[-32,-52;
                -32,-58; -74,-58; -74,-52], style(color=3, rgbcolor={0,0,255}));
        end FlybackConverterDymola;

        model FlybackConverterDEVS
          "ModelicaDEVS simulation of the flyback converter."
          annotation (Diagram(
              Text(
                extent=[-20,82; 2,78],
                string="-uR",
                style(color=10, rgbcolor={95,95,95})),
              Text(
                extent=[26,82; 48,78],
                string="uR",
                style(color=10, rgbcolor={95,95,95})),
              Text(
                extent=[60,48; 82,44],
                style(color=10, rgbcolor={95,95,95}),
                string="iL"),
              Text(
                extent=[-18,48; 4,44],
                style(color=10, rgbcolor={95,95,95}),
                string="uL"),
              Text(
                extent=[-58,16; -36,12],
                style(color=10, rgbcolor={95,95,95}),
                string="u0"),
              Text(
                extent=[22,48; 44,44],
                style(color=10, rgbcolor={95,95,95}),
                string="diL/dt"),
              Text(
                extent=[32,-32; 54,-36],
                style(color=10, rgbcolor={95,95,95}),
                string="duR/dt"),
              Text(
                extent=[-10,-32; 12,-36],
                style(color=10, rgbcolor={95,95,95}),
                string="iC"),
              Text(
                extent=[-10,-62; 12,-66],
                style(color=10, rgbcolor={95,95,95}),
                string="iR"),
              Text(
                extent=[32,-62; 54,-66],
                string="uR",
                style(color=10, rgbcolor={95,95,95})),
              Text(
                extent=[-86,-44; -64,-48],
                style(color=10, rgbcolor={95,95,95}),
                string="iL"),
              Text(
                extent=[-44,-46; -22,-50],
                style(color=10, rgbcolor={95,95,95}),
                string="-"),
              Text(
                extent=[-44,-30; -22,-34],
                style(color=10, rgbcolor={95,95,95}),
                string="+"),
              Text(
                extent=[72,-32; 94,-36],
                string="uR",
                style(color=10, rgbcolor={95,95,95})),
              Text(
                extent=[-76,46; -54,44],
                style(color=10, rgbcolor={95,95,95}),
                string="0 or 1"),
              Text(
                extent=[-90,-26; -68,-28],
                style(color=10, rgbcolor={95,95,95}),
                string="0 or 1")),
            experiment(StopTime=0.002, Algorithm="Lsodar"),
            experimentSetupOutput(
              states=false,
              derivatives=false,
              inputs=false,
              auxiliaries=false),
            Coordsys(extent=[-120,-100; 120,100]),
            Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>ModelicaDEVS Flyback Converter</b></font>
<br/>
<br/>
In order to be able to model the flyback converter in ModelicaDEVS or PowerDEVS, we need to map the behaviour of the converter to a block diagram, which then can be reproduced by means of the components from the PowerDEVS/ModelicaDEVS libraries. Block diagrams are obtained by causalising the equations of the system (circuit) according to the Tarjan algorithm as explained in [Cellier05].
<br/>
Unfortunately in our case, the presence of the switch coupled with the directed input-output data flow intrinsic to DEVS models cause an unsolvable problem if we just attempt to build our block diagram from the common set of equations given in <a href=\"Modelica://ModelicaDEVS.Examples.Electrical.FlybackConverter.FlybackConverterDymola\">
FlybackConverterDymola</a>. It is therefore necessary to split the equations in two sets, one for each switch position (for each operation phase of the converter), thereby eliminating the switching component. The following figure shows the respective electrical circuits for the two switch positions (closed/open).
<br/>
<br/>
<center><img src=\"../Images/FlybackEquationsSplit.png\" width=\"500\"></center>
<br/>
<br/>
The following sets of equations describe the two operation phases of the converter:
<br/>
<br/>
<center>
<table>
<tr>
<td>
Switch closed
<br/>
<br/>
U<sub>0</sub> =  constant<br/>
u<sub>L</sub> =  U<sub>0</sub> <br/>
u<sub>L</sub> =  L * di<sub>L</sub>/dt <br/>
i<sub>C</sub> =  C * u<sub>R</sub>/dt <br/>
u<sub>R</sub> =  R * i<sub>R</sub> <br/>
i<sub>R</sub> =  -i<sub>C</sub> <br/>
i<sub>0</sub> =  i<sub>L</sub> <br/>
</td>
<td>
Switch open
<br/>
<br/>
i<sub>D</sub> =  i<sub>L </sub> <br/>
i<sub>D</sub> =  i<sub>C </sub>+ i<sub>R </sub> <br/>
u<sub>L</sub> =  L * di<sub>L</sub>/dt <br/>
i<sub>C</sub> =  C * u<sub>R</sub>/dt <br/>
u<sub>R</sub> =  R * i<sub>R</sub> <br/>
u<sub>R</sub> =  -u<sub>L</sub> <br/>
</td>
</tr>
</table>
</center>

Now we have to causalise the equations, where causalising means to determine which equation we solve for which variable. To this end, we apply the Tarjan algorithm [Cellier05]: we mark all variables appearing in the equations with labels \"solve for\" and \"known\". By convention [Cellier91], known variables are underlined and variables for which a certain equation has to be solved are put into square brackets.
<br/>
The following rules help a) to find a good starting point for applying the algorithm, and b) to choose the next variable to be marked:
<ul>
<li>
Outputs of integrators are considered to be known. Hence, if we have an equation like u<sub>L</sub>= L * di<sub>L</sub>/dt, all variables i<sub>L</sub> occurring in other equations can be underlined (remember that known variables are marked by underlining them).
</li>
<li>
An equation that contains only one unknown variable has to be solved for the particular variable that therefore can be put in square brackets.
</li>
<li>
A variable that occurs in only one equation has to be obtained from that equation, i.e., the equation has to be solved for the particular variable. Thus, the variable can again be put into square brackets.
</li>
<li>
As soon as a variable has been put into square brackets, all its further occurrences in other equations can be labelled \"known\" since the value of that variable will be obtained from the equation where it is labelled \"solve for\".
</li>
</ul>
The causalised version of the two equation sets listed before looks as follows (in order to be able to trace the algorithm, the variables are numbered in the order they were underlined or bracketed):
<br/>
<br/>
<center>

<table>
<tr>
<td>
Switch closed
<br/>
<br/>
[U<sub>0</sub>] <sup>(1b)</sup> =  <u>constant</u> <sup>(1a)</sup><br/>
[u<sub>L</sub>] <sup>(1d)</sub> =  <u>U<sub>0</sub></u> <sup>(1c)</sup><br/>
<u>u<sub>L</sub></u> <sup>(1e)</sub> =  L * [di<sub>L</sub>/dt] <sup>(1f) </sup> <br/>
<u>i<sub>C</sub></u> <sup>(2e)</sub> =  C * [du<sub>R</sub>/dt] <sup>(2f) </sup><br/>
<u>u<sub>R</sub></u> <sup>(2a)</sub> =  R * [i<sub>R</sub>] <sup>(2b) </sup><br/>
<u>i<sub>R</sub></u> <sup>(2c)</sup> =  -[i<sub>C</sub>] <sup>(2d) </sup><br/>
[i<sub>0</sub>] <sup>(1h)</sup> =  <u>i<sub>L</sub></u> <sup>(1g)</sup><br/>

</td>
<td>
Switch open
<br/>
<br/>
[i<sub>D</sub>] <sup>(1b)</sup> =  <u>i<sub>L</sub></u> <sup>(1a)</sup><br/>
<u>i<sub>D</sub></u> <sup>(1c)</sup> =  [i<sub>C</sub>]<sup>(2d)</sup>+ <u>i<sub>R</sub></u> <sup>(2c)</sup> <br/>
<u>u<sub>L</sub></u> <sup>(3c)</sup> =  L * [di<sub>L</sub>/dt] <sup>(3d) </sup><br/>
<u>i<sub>C</sub></u> <sup>(2e)</sup> =  C * [du<sub>R</sub>/dt] <sup>(2f)</sup> <br/>
<u>u<sub>R</sub></u> <sup>(2a)</sup> =  R * [i<sub>R</sub>] <sup>(2b)</sup> <br/>
<u>u<sub>R</sub></u> <sup>(3a)</sup> =  -[u<sub>L</sub>] <sup>(3b)</sup>
</td>
</tr>
</table>
</center>
<br/>
<br/>
The two sets of causalised equations define exactly the way variables depend on each other, and we are able to build the required block diagram(s). In order to illustrate how to get from a set of equations to a block diagram, the subsequent list depicts the various steps during the synthesis of the block diagram representing the first set of causalised equations.

<ol>
<img src=\"../Images/FlybackBlock1a.png\" width=\"200\"> <br/>
<li>
Although it theoretically does not matter with which block/equation we start, it is recommended to first insert the integrators.
</li>
<br/>
<br/>
<img src=\"../Images/FlybackBlock1b.png\" width=\"200\"> <br/>
<li>
Our first equation we want to represent preferably depends on the integrator variables: i<sub>C</sub>= C * du<sub>R</sub>/dt
</li>
<br/>
<br/>
<img src=\"../Images/FlybackBlock1c.png\" width=\"200\"><br/>
<li>
As a next step we include the equations i<sub>R </sub> = -i<sub>C</sub> and u<sub>R</sub> = R * i<sub>R</sub>
</li>
<br/>
<br/>
<img src=\"../Images/FlybackBlock1d.png\" width=\"200\"><br/>
<li>
There are no dependencies anymore, so we insert an integrator again.
</li>
<br/>
<br/>
<img src=\"../Images/FlybackBlock1e.png\" width=\"200\"><br/>
<li>
u<sub>L</sub>= L * di<sub>L</sub>/dt
</li>
<br/>
<br/>
<img src=\"../Images/FlybackBlock1g.png\" width=\"200\"> <br/>
<li>
Finally, we represent the equations u<sub>L</sub>= U<sub>0</sub> and i<sub>0</sub>= i<sub>L</sub>, and thereby complete the block diagram of the first equation set.
</li>
</ol>


The following figure shows the two (finished) block diagrams, where the second one has been built according to the same method that has been applied for the first one.
<br/>
Note that the two resulting diagrams are not completely different from each other but share common parts, which will be helpful as we shall see soon.
<br/>
<br/>
<center>
<table>
<tr>
<td><img src=\"../Images/FlybackBlock1.png\" width=\"200\"></td>
<td><img src=\"../Images/FlybackBlock2.png\" width=\"200\"></td>
</tr>
</table>
</center>
<br/>

The last step towards a complete single block diagram representing the flyback converter, is to merge the two partial diagrams presented above. To this end, recall that initially, we split the original set of equations to eliminate the switch, or, in other terms, to obtain a diagram for each switch position. Hence, while merging the two diagrams, we have to re-insert the switching component. The switch can be said to alternate between the two diagrams: when it is open, the first block diagram is valid, when it is closed, the second one becomes active.
<br/>
Fortunately, the two diagrams share a similar structure, which eases the merging process a lot: normally we would have to build both of the models and in some way deactivate one of them when the other becomes active. In our case however, we just look for a way how to transform one of the diagrams into the other one. We find that the two critical variables are u<sub>L</sub> and i<sub>C</sub> since their definition in the first diagram is different from their definition in the second one:
<ul>
<li>
When the switch is closed (first diagram), u<sub>L</sub> equals u<sub>0</sub>, thus the constant value given by the parameters of the model. The current i<sub>C</sub> depends only on i<sub>R</sub> instead of a second variable as it is the case for the situation of an open switch.
</li>
<li>
When the switch is open (second diagram), u<sub>L</sub> is equal to -u<sub>R</sub> and i<sub>C</sub> is determined by both i<sub>D</sub> and i<sub>R</sub>.
</li>
</ul>

Hence, if we place our switching component in such a way that it switches a) the value for u<sub>L</sub> between u<sub>0</sub> and -u<sub>R</sub>, and b) the value of i<sub>C</sub> between -i<sub>R</sub> and i<sub>D</sub>-i<sub>R</sub>, we obtain a model that fully represents the flyback converter.
<br/>
Such a model is shown in the subsequent figure. Note that there are still two switches, which however correctly represent the single switch in the original flyback converter, since they flip at the same time and thus could be coupled.
<br/>
<br/>
<center><img src=\"../Images/FlybackBlockFinal.png\" width=\"400\"></center>
<br/>
<br/>
<br/>

The corresponding ModelicaDEVS model is built according to the model in the figure above, and hence its structure should be clear to a large extent. Only the switching parts may need a brief explanation.
<ul>
<li>
The Square block controls the flipping frequency of the two switches. It generates a signal that oscillates between 1 and 0 (1 = switch open, 0 = switch closed).
</li>
<li>
The upper switch in the above figure is modelled by a Switch block with the parameter level set to zero. It is important to mention that a level value of 1 would <b>not</b> yield the same results since the Switch connects the first input port to the output port if the second input port is bigger than the level value and the third input port otherwise, namely if the second input port is smaller or equal than the value of level. Hence, the switch would not flip at all.
<br/>
The Constant block represents the input voltage u<sub>0</sub>.
<br/>
Given that the switch either directs the first or the third input port to its output port, depending on the output of the Square block, this set-up provides the Gain1 block with either the constant value (u<sub>0</sub>) or the signal from the Integrator2 block (u<sub>R</sub>).
</li>
<li>
The lower switch is represented by a simple Multiplier block the output of which represents the current i<sub>D</sub>. Due to the multiplication of the output of Integrator1 (i<sub>L</sub>) by the signal from the Square block (0 or 1), i<sub>D</sub> oscillates between 0 (phase 1, switch closed) and the value it is provided by Integrator1 (phase 2, switch open).
<br/>
This precisely corresponds to the real situation where the current through the diode is zero during phase 1 (diode locked), and non-zero during phase 2.
</li>
</ul>
<br/>
<br/>

<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
The four output variables, Inductor_i_DEVS, Inductor_i, Resistor_u and Resistor_u, give both the original DEVS output and the interpolated version of the current through the inductor and the voltage across the load resistance.
<br/>
<br/>
</html>"));
          output Real Inductor_i;
          output Real Resistor_u;
          output Real Inductor_i_DEVS;
          output Real Resistor_u_DEVS;

          ModelicaDEVS.FunctionBlocks.Integrator Integrator1(quantum=0.1)
                                                annotation (extent=[44,30; 64,50]);
          ModelicaDEVS.FunctionBlocks.Integrator Integrator2(quantum=0.1)
                                                annotation (extent=[56,-50; 76,
                -30]);
          ModelicaDEVS.FunctionBlocks.Gain Gain1(g=1/(200E-6))
                                             annotation (extent=[2,30; 22,50]);
          ModelicaDEVS.FunctionBlocks.Gain Gain2(g=1/(22E-6))
                                            annotation (extent=[10,-50; 30,-30]);
          ModelicaDEVS.FunctionBlocks.Gain Gain3(g=1/5)
                                           annotation (extent=[32,-80; 10,-60]);
          ModelicaDEVS.FunctionBlocks.Gain Gain4(g=-1)
                                          annotation (extent=[24,64; 4,84]);
          ModelicaDEVS.FunctionBlocks.Add Add1(c1=-1, c0=1)
                                         annotation (extent=[-30,-50; -8,-30]);
          ModelicaDEVS.SourceBlocks.Square Square1(offset=0.5,
            f=1/(1.67E-5),
            a=0.5,
            d=2*100/3)
                      annotation (extent=[-118,-6; -98,14]);
          ModelicaDEVS.FunctionBlocks.Switch Switch1(level=0)
                                                   annotation (extent=[-36,30;
                -16,50]);
          ModelicaDEVS.SourceBlocks.Constant Constant1(v=40)
                                                annotation (extent=[-76,10; -56,
                30]);
          ModelicaDEVS.FunctionBlocks.Multiplier Multiplier1
                                                annotation (extent=[-70,-46; -48,
                -26]);
          ModelicaDEVS.SinkBlocks.Interpolator Interpolator1
                                                annotation (extent=[100,0; 120,20]);
          ModelicaDEVS.SinkBlocks.Interpolator Interpolator2
            annotation (extent=[100,-68; 120,-48]);
          inner ModelicaDEVS.Miscellaneous.worldModel world(qss=3)
            annotation (extent=[-120,80; -100,100]);

        equation
          Inductor_i=Interpolator1.y;
          Resistor_u=Interpolator2.y;
          Inductor_i_DEVS=Integrator1.outPort.signal[1];
          Resistor_u_DEVS=Integrator2.outPort.signal[1];
          connect(Gain2.outPort, Integrator2.inPort) annotation (points=[32,-40;
                54,-40],
                      style(color=3, rgbcolor={0,0,255}));
          connect(Integrator2.outPort, Gain3.inPort) annotation (points=[78,-40;
                88,-40; 88,-70; 34.2,-70],
                                         style(color=3, rgbcolor={0,0,255}));
          connect(Gain3.outPort, Add1.inPort2) annotation (points=[7.8,-70; -40,
                -70; -40,-44; -32.2,-44],
                                   style(color=3, rgbcolor={0,0,255}));
          connect(Square1.outPort, Switch1.inPort2) annotation (points=[-96,4;
                -88,4; -88,40; -38,40],style(color=3, rgbcolor={0,0,255}));
          connect(Multiplier1.inPort1, Square1.outPort) annotation (points=[-72.2,
                -32; -88,-32; -88,4; -96,4],  style(color=3, rgbcolor={0,0,255}));
          connect(Multiplier1.outPort, Add1.inPort1) annotation (points=[-45.8,
                -36; -32.2,-36],            style(color=3, rgbcolor={0,0,255}));
          connect(Integrator2.outPort, Gain4.inPort) annotation (points=[78,-40;
                88,-40; 88,74; 26,74],style(color=3, rgbcolor={0,0,255}));
          connect(Constant1.outPort, Switch1.inPort3) annotation (points=[-54,20;
                -46,20; -46,34; -38,34],           style(color=3, rgbcolor={0,0,255}));
          connect(Gain4.outPort, Switch1.inPort1) annotation (points=[2,74; -46,
                74; -46,46; -38,46],   style(color=3, rgbcolor={0,0,255}));
          connect(Switch1.outPort, Gain1.inPort) annotation (points=[-14,40; 0,40],
              style(color=3, rgbcolor={0,0,255}));
          connect(Gain1.outPort, Integrator1.inPort)
            annotation (points=[24,40; 42,40],     style(color=3, rgbcolor={0,0,255}));
          connect(Integrator1.outPort, Multiplier1.inPort2) annotation (points=[66,40;
                78,40; 78,-14; -94,-14; -94,-40; -72.2,-40],   style(color=3, rgbcolor=
                  {0,0,255}));
          connect(Add1.outPort, Gain2.inPort)
            annotation (points=[-5.8,-40; 8,-40], style(color=3, rgbcolor={0,0,255}));
          connect(Integrator1.outPortInterpolator, Interpolator1.inPortInterpolator)
            annotation (points=[54,28; 54,10; 98,10],                    style(
                color=1, rgbcolor={255,0,0}));
          connect(Integrator2.outPortInterpolator, Interpolator2.
            inPortInterpolator) annotation (points=[66,-52; 66,-58; 98,-58],
                      style(color=1, rgbcolor={255,0,0}));

        end FlybackConverterDEVS;

        model FlybackConverterMixed
          "ModelicaDEVS/standard Dymola mixed simulation of the flyback converter."
          output Real Inductor_i;
          output Real Resistor_u;
          Modelica.Electrical.Analog.Ideal.IdealDiode IdealDiode1(Vknee=0)
            annotation (extent=[20,-32; 40,-12]);
          Modelica.Electrical.Analog.Sources.ConstantVoltage ConstantVoltage1(V=40)
            annotation (extent=[-84,-32; -64,-52],
                                                 rotation=90);
          annotation (Diagram,
            experiment(StopTime=0.002, Algorithm="Lsodar"),
            experimentSetupOutput(
              states=false,
              derivatives=false,
              inputs=false,
              auxiliaries=false),
            Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Dymola/ModelicaDEVS Flyback Converter</b></font>
<br/>
<br/>
This model simulates the flyback converter example shown in <a href=\"Modelica://ModelicaDEVS.Examples.Electrical.FlybackConverter.FlybackConverterDymola\">
FlybackConverterDymola</a>. The only difference is that instead of a standard Dymola capacitor it uses the ModelicaDEVS capacitor (CapacitorDEVS).
<br/>
<br/>
Remark: this model does not work yet, due to the differentiation problem described in the documentation section of the <a href=\"Modelica://ModelicaDEVS.Examples.Electrical.AdditionalBlocks.CapacitorDEVS\">
CapacitorDEVS</a> block.
<br/>
<br/>
<br/>

<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
The two output variables, Inductor_i and Resistor_u, give the current through the inductor and the voltage across the load resistance.
</html>"));
          Modelica.Electrical.Analog.Basic.Resistor Resistor1(R=5)
            annotation (extent=[76,-32; 96,-52],
                                               rotation=90);
          Modelica.Electrical.Analog.Basic.Inductor Inductor1(L=200E-6)
            annotation (extent=[-42,-52; -22,-32],
                                                 rotation=90);
          Modelica.Electrical.Analog.Ideal.IdealClosingSwitch
            IdealClosingSwitch1
            annotation (extent=[-64,-32; -44,-12]);
          Modelica.Electrical.Analog.Ideal.IdealTransformer Transformer1(n=-1)
            annotation (extent=[-12,-56; 6,-28]);
          Modelica.Blocks.Sources.BooleanPulse BooleanPulse1(width=100/3, period=1.67E-5)
            annotation (extent=[-82,20; -62,40]);
          Modelica.Electrical.Analog.Basic.Ground Ground1
            annotation (extent=[-72,-86; -52,-66]);
          Modelica.Electrical.Analog.Basic.Ground Ground2
            annotation (extent=[92,-84; 112,-64]);
          ModelicaDEVS.Examples.Electrical.AdditionalBlocks.CapacitorDEVS
            CapacitorDEVS1(                                                              C=22E-6,
            period=1.67E-6)
            annotation (extent=[44,-52; 64,-32], rotation=-90);

        equation
          Inductor_i=Inductor1.i;
          Resistor_u=Resistor1.v;
          connect(ConstantVoltage1.p, IdealClosingSwitch1.p)
                                                         annotation (points=[-74,-32;
                -74,-22; -64,-22], style(color=3, rgbcolor={0,0,255}));
          connect(Transformer1.p2, IdealDiode1.p) annotation (points=[6,-35; 6,-22; 20,
                -22], style(color=3, rgbcolor={0,0,255}));
          connect(BooleanPulse1.y, IdealClosingSwitch1.control) annotation (points=[-61,30;
                -54,30; -54,-15],     style(color=5, rgbcolor={255,0,255}));
          connect(Ground1.p, ConstantVoltage1.n)
                                             annotation (points=[-62,-66; -62,-58; -74,
                -58; -74,-52], style(color=3, rgbcolor={0,0,255}));
          connect(Transformer1.p1, Inductor1.n) annotation (points=[-12,-35; -14,-35;
                -14,-22; -32,-22; -32,-32], style(color=3, rgbcolor={0,0,255}));
          connect(Inductor1.n, IdealClosingSwitch1.n) annotation (points=[-32,-32; -32,
                -22; -44,-22], style(color=3, rgbcolor={0,0,255}));
          connect(Inductor1.p, Transformer1.n1) annotation (points=[-32,-52; -32,-58;
                -12,-58; -12,-49], style(color=3, rgbcolor={0,0,255}));
          connect(Inductor1.p, ConstantVoltage1.n) annotation (points=[-32,-52; -32,-58;
                -74,-58; -74,-52], style(color=3, rgbcolor={0,0,255}));
          connect(Ground2.p, Resistor1.n) annotation (points=[102,-64; 102,-52;
                86,-52], style(color=3, rgbcolor={0,0,255}));
          connect(IdealDiode1.n, CapacitorDEVS1.p) annotation (points=[40,-22; 54,-22;
                54,-32], style(color=3, rgbcolor={0,0,255}));
          connect(CapacitorDEVS1.n, Transformer1.n2) annotation (points=[54,-52; 54,-58;
                6,-58; 6,-49], style(color=3, rgbcolor={0,0,255}));
          connect(CapacitorDEVS1.p, Resistor1.p) annotation (points=[54,-32; 54,
                -22; 86,-22; 86,-32], style(color=3, rgbcolor={0,0,255}));
          connect(CapacitorDEVS1.n, Resistor1.n) annotation (points=[54,-52; 54,
                -58; 86,-58; 86,-52], style(color=3, rgbcolor={0,0,255}));
        end FlybackConverterMixed;

        model FlybackConverterMixedNumerical
          "ModelicaDEVS/standard Dymola mixed (numerically approximated) simulation of the flyback converter."
          output Real Inductor_i;
          output Real Resistor_u;
          Modelica.Electrical.Analog.Ideal.IdealDiode IdealDiode1(Vknee=0)
            annotation (extent=[20,-32; 40,-12]);
          Modelica.Electrical.Analog.Sources.ConstantVoltage ConstantVoltage1(V=40)
            annotation (extent=[-84,-32; -64,-52],
                                                 rotation=90);
          annotation (Diagram,
            experiment(StopTime=0.002, Algorithm="Lsodar"),
            experimentSetupOutput(
              states=false,
              derivatives=false,
              inputs=false,
              auxiliaries=false),
            Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Dymola/ModelicaDEVS Numerically Approximated Flyback Converter</b></font>
<br/>
<br/>
This model simulates the flyback converter example shown in <a href=\"Modelica://ModelicaDEVS.Examples.Electrical.FlybackConverter.FlybackConverterDymola\">
FlybackConverterDymola</a>. The only difference is that instead of a standard Dymola capacitor it uses the numerical ModelicaDEVS capacitor (CapacitorDEVSNumerical).
<br/>
<br/>
Note that - contrary to the FlybackConverterMixed example - the capacitor in this model performs only numerical differentiation.
<br/>
<br/>
<br/>

<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
The two output variables, Inductor_i and Resistor_u, give the current through the inductor and the voltage across the load resistance.
</html>"));
          Modelica.Electrical.Analog.Basic.Resistor Resistor1(R=5)
            annotation (extent=[96,-32; 76,-52],
                                               rotation=90);
          Modelica.Electrical.Analog.Basic.Inductor Inductor1(L=200E-6)
            annotation (extent=[-42,-32; -22,-52],
                                                 rotation=90);
          Modelica.Electrical.Analog.Ideal.IdealClosingSwitch
            IdealClosingSwitch1
            annotation (extent=[-64,-32; -44,-12]);
          Modelica.Electrical.Analog.Ideal.IdealTransformer Transformer1(n=-1)
            annotation (extent=[-12,-56; 6,-28]);
          Modelica.Blocks.Sources.BooleanPulse BooleanPulse1(width=100/3, period=1.67E-5)
            annotation (extent=[-82,20; -62,40]);
          Modelica.Electrical.Analog.Basic.Ground Ground1
            annotation (extent=[-72,-86; -52,-66]);
          Modelica.Electrical.Analog.Basic.Ground Ground2
            annotation (extent=[64,-90; 84,-70]);
          ModelicaDEVS.Examples.Electrical.AdditionalBlocks.CapacitorDEVSNumerical
            CapacitorDEVS1(                                                                       C=22E-6, qssMethod=3,
            d=0.1)
            annotation (extent=[44,-52; 64,-32], rotation=-90);

        equation
          Inductor_i=Inductor1.i;
          Resistor_u=Resistor1.v;
          connect(ConstantVoltage1.p, IdealClosingSwitch1.p)
                                                         annotation (points=[-74,-32;
                -74,-22; -64,-22], style(color=3, rgbcolor={0,0,255}));
          connect(Transformer1.p2, IdealDiode1.p) annotation (points=[6,-35; 6,-22; 20,
                -22], style(color=3, rgbcolor={0,0,255}));
          connect(BooleanPulse1.y, IdealClosingSwitch1.control) annotation (points=[-61,30;
                -54,30; -54,-15],     style(color=5, rgbcolor={255,0,255}));
          connect(Ground1.p, ConstantVoltage1.n)
                                             annotation (points=[-62,-66; -62,-58; -74,
                -58; -74,-52], style(color=3, rgbcolor={0,0,255}));
          connect(Ground2.p, Resistor1.n) annotation (points=[74,-70; 74,-58; 86,-58;
                86,-52], style(color=3, rgbcolor={0,0,255}));
          connect(IdealDiode1.n, CapacitorDEVS1.p) annotation (points=[40,-22; 54,-22;
                54,-32], style(color=3, rgbcolor={0,0,255}));
          connect(CapacitorDEVS1.p, Resistor1.p) annotation (points=[54,-32; 54,-22; 86,
                -22; 86,-32], style(color=3, rgbcolor={0,0,255}));
          connect(Resistor1.n, CapacitorDEVS1.n) annotation (points=[86,-52; 86,-58; 54,
                -58; 54,-52], style(color=3, rgbcolor={0,0,255}));
          connect(CapacitorDEVS1.n, Transformer1.n2) annotation (points=[54,-52; 54,-58;
                6,-58; 6,-49], style(color=3, rgbcolor={0,0,255}));
          connect(IdealClosingSwitch1.n, Inductor1.p) annotation (points=[-44,-22;
                -32,-22; -32,-32], style(color=3, rgbcolor={0,0,255}));
          connect(Inductor1.n, ConstantVoltage1.n) annotation (points=[-32,-52;
                -32,-58; -74,-58; -74,-52], style(color=3, rgbcolor={0,0,255}));
          connect(Inductor1.p, Transformer1.p1) annotation (points=[-32,-32; -32,
                -22; -12,-22; -12,-35], style(color=3, rgbcolor={0,0,255}));
          connect(Transformer1.n1, Inductor1.n) annotation (points=[-12,-49; -12,
                -58; -32,-58; -32,-52], style(color=3, rgbcolor={0,0,255}));
        end FlybackConverterMixedNumerical;
        annotation (Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Flyback Converter</b></font>
<br/>
<br/>
The flyback converter example was used to measure the run-time efficiency of ModelicaDEVS compared to standard Dymola and <a href=\"Modelica://ModelicaDEVS.UsersGuide.PowerDEVS\">PowerDEVS</a>.
<br/>
<br/>
The different flyback converter models simulate the flyback converter behaviour in standard Dymola, ModelicaDEVS and in a mixed simulation (once using analytical differentiation, once numerical).
<br/>
<br/>
Note that the third model (FlybackConverterMixed) does not work due to the problem described along with the <a href=\"Modelica://ModelicaDEVS.Examples.Electrical.AdditionalBlocks.CapacitorDEVS\">
CapacitorDEVS</a> block.
</html>"));
      end FlybackConverter;
      annotation (Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Electrical</b></font>
<br/>
<br/>
This package contains two different electrical examples: a simple circuit, and the flyback converter. Furthermore there is an additional package \"AdditionalBlocks\" that contains a number of blocks that were programmed especially to build the electrical examples.
</html>"));
    end Electrical;

    package Miscellaneous
      model LotkaVolterra "Lotka Volterra prey-predator behaviour"
        output Real Prey;
        output Real Predator;

        ModelicaDEVS.FunctionBlocks.Multiplier Mult1
                            annotation (extent=[-56,-10; -36,10]);
        ModelicaDEVS.FunctionBlocks.Add Add1(c0=-0.1, c1=0.1)
                                           annotation (extent=[-4,30; 16,50]);
        ModelicaDEVS.FunctionBlocks.Add Add2(c0=0.1, c1=-0.1)
                                           annotation (extent=[-4,-44; 16,-24]);
        ModelicaDEVS.FunctionBlocks.Integrator Integrator1(quantum=0.001, startX=0.5)
          annotation (extent=[38,30; 58,50]);
        ModelicaDEVS.FunctionBlocks.Integrator Integrator2(quantum=0.001, startX=0.5)
          annotation (extent=[38,-44; 58,-24]);
        annotation (Diagram(
            Text(
              extent=[0,48; -18,48],
              style(color=10, rgbcolor={95,95,95}),
              string="-0.1"),
            Text(
              extent=[36,-28; 18,-28],
              style(color=10, rgbcolor={95,95,95}),
              string="dy/dt"),
            Text(
              extent=[74,46; 56,46],
              style(color=10, rgbcolor={95,95,95}),
              string="x"),
            Text(
              extent=[76,-28; 58,-28],
              style(color=10, rgbcolor={95,95,95}),
              string="y"),
            Text(
              extent=[22,60; -6,60],
              style(color=10, rgbcolor={95,95,95}),
              string="dx/dt=Ax-Bxy"),
            Text(
              extent=[24,-14; -10,-14],
              style(color=10, rgbcolor={95,95,95}),
              string="dy/dt=-Cy+Dxy"),
            Text(
              extent=[0,-44; -18,-44],
              style(color=10, rgbcolor={95,95,95}),
              string="-0.1"),
            Text(
              extent=[0,30; -18,30],
              style(color=10, rgbcolor={95,95,95}),
              string="0.1"),
            Text(
              extent=[0,-26; -18,-26],
              style(color=10, rgbcolor={95,95,95}),
              string="0.1"),
            Text(
              extent=[36,46; 18,46],
              style(color=10, rgbcolor={95,95,95}),
              string="dx/dt"),
            Text(
              extent=[-20,6; -38,6],
              style(color=10, rgbcolor={95,95,95}),
              string="x*y")), Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Predator-Prey Interaction (Lotka-Volterra)</b></font>
<br/>
<br/>
This example has been taken from the PowerDEVS software.
<br/>
<br/>
The Lotka-Volterra equations describe an ecological predator-prey (or parasite-host) model which assumes that, for a set of fixed positive constants A (the growth rate of prey), B (the rate at which predators destroy prey), C (the death rate of predators), and D (the rate at which predators increase by consuming prey), the following conditions hold.
<ol>
<li>A prey population x increases at a rate dx=A*x*dt (proportional to the number of prey) but is simultaneously destroyed by predators at a rate dx=-B*x*y*dt (proportional to the product of the numbers of prey and predators).
</li>
<li>
A predator population y decreases at a rate dy=-C*y*dt (proportional to the number of predators), but increases at a rate dy=D*x*y*dt (again proportional to the product of the numbers of prey and predators).
</li>
</ol>
This gives the coupled differential equations:
<br/>
<center>
dx/dt=A*x-B*x*y
<br/>
dy/dt=-C*y+D*x*y
</center>
<br/>
<br/>
<b>
Reference: http://mathworld.wolfram.com/Lotka-VolterraEquations.html
</b>
<br/>
<br/>
<br/>
The current ModelicaDEVS predator-prey model features the following parameters: A=B=C=D=0.1
<br/>
<br/>
<br/>
<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
The output variable Prey represents the behaviour of the prey population, the variable Predators shows the trajectory of the predator polutation.
<br/>
<br/>
</html>"),experiment(StopTime=100, Algorithm="Lsodar"),
          experimentSetupOutput(
            states=false,
            derivatives=false,
            inputs=false,
            auxiliaries=false));
        inner ModelicaDEVS.Miscellaneous.worldModel world(qss=1)
                                                annotation (extent=[-100,80;
              -80,100]);

      equation
        Prey=Integrator1.outPort.signal[1];
        Predator=Integrator2.outPort.signal[1];
        connect(Add2.outPort, Integrator2.inPort)
          annotation (points=[18,-34; 36,-34],   style(color=3, rgbcolor={0,0,255}));
        connect(Add1.outPort, Integrator1.inPort)
          annotation (points=[18,40; 36,40],   style(color=3, rgbcolor={0,0,255}));
        connect(Integrator1.outPort, Add1.inPort2)           annotation (points=[60,40;
              72,40; 72,14; -18,14; -18,36; -6,36],style(color=3, rgbcolor={0,0,255}));
        connect(Integrator1.outPort, Mult1.inPort1)           annotation (points=[60,40;
              72,40; 72,76; -64,76; -64,4; -58,4],     style(color=3, rgbcolor={0,0,
                255}));
        connect(Integrator2.outPort, Mult1.inPort2)           annotation (points=[60,-34;
              72,-34; 72,-76; -64,-76; -64,-4; -58,-4],      style(color=3, rgbcolor=
                {0,0,255}));
        connect(Integrator2.outPort, Add2.inPort2)           annotation (points=[60,-34;
              72,-34; 72,-58; -24,-58; -24,-38; -6,-38],   style(color=3, rgbcolor={0,
                0,255}));
        connect(Mult1.outPort, Add2.inPort1)           annotation (points=[-34,0;
              -24,0; -24,-30; -6,-30],
                                 style(color=3, rgbcolor={0,0,255}));
        connect(Mult1.outPort, Add1.inPort1)           annotation (points=[-34,0;
              -24,0; -24,44; -6,44],
                               style(color=3, rgbcolor={0,0,255}));
      end LotkaVolterra;

      model TwoLoops "Model containing two loops."
        annotation (uses(Modelica(version="1.6")), Diagram,
          experiment(StopTime=10, Algorithm="Lsodar"),
          experimentSetupOutput(
            states=false,
            derivatives=false,
            inputs=false,
            auxiliaries=false),
          Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Two Loops</b></font>
<br/>
<br/>
This is just a \"random\" dummy DEVS model. Initially it was used to test the correct behaviour of a ModelicaDEVS model containing two loops.
<br/>
<br/>
<br/>
<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
There are two output variables declared: InterpolatorOutput1 and InterpolatorOutput2. Since the scope of this example was rather the testing of loops in ModelicaDEVS, they have no special meaning.
</html>"));
        output Real InterpolatorOutput1;
        output Real InterpolatorOutput2;

        ModelicaDEVS.SourceBlocks.Sine Sine1 annotation (extent=[-88,40; -68,60]);
        ModelicaDEVS.SourceBlocks.Step Step1(ts=2, a=6)
          annotation (extent=[-88,-46; -68,-26]);
        ModelicaDEVS.FunctionBlocks.Add Add1(c1=-0.1)
                                             annotation (extent=[-18,-42; 2,-22]);
        ModelicaDEVS.FunctionBlocks.Add Add2(c0=-0.1, c1=-1)
          annotation (extent=[-20,36; 0,56]);
        ModelicaDEVS.FunctionBlocks.Integrator Integrator1
          annotation (extent=[26,36; 46,56]);
        ModelicaDEVS.FunctionBlocks.Integrator Integrator2
          annotation (extent=[30,-42; 50,-22]);
        ModelicaDEVS.SinkBlocks.Interpolator Interpolator1
          annotation (extent=[74,18; 94,38]);
        ModelicaDEVS.SinkBlocks.Interpolator Interpolator2
          annotation (extent=[74,-62; 94,-42]);
        inner ModelicaDEVS.Miscellaneous.worldModel world(qss=1)
                                           annotation (extent=[-100,80; -80,100]);

      equation
        InterpolatorOutput1=Interpolator1.y;
        InterpolatorOutput2=Interpolator2.y;
        connect(Sine1.outPort, Add2.inPort1)  annotation (points=[-66,50; -22,
              50],         style(color=3, rgbcolor={0,0,255}));
        connect(Step1.outPort, Add1.inPort2)  annotation (points=[-66,-36; -20,
              -36],              style(color=3, rgbcolor={0,0,255}));
        connect(Add2.outPort, Integrator1.inPort) annotation (points=[2,46; 24,
              46], style(color=3, rgbcolor={0,0,255}));
        connect(Integrator1.outPort, Add1.inPort1) annotation (points=[48,46;
              56,46; 56,2; -32,2; -32,-28; -20,-28], style(color=3, rgbcolor={0,
                0,255}));
        connect(Add1.outPort, Integrator2.inPort) annotation (points=[4,-32; 28,
              -32], style(color=3, rgbcolor={0,0,255}));
        connect(Integrator2.outPort, Add2.inPort2) annotation (points=[52,-32;
              60,-32; 60,14; -32,14; -32,42; -22,42], style(color=3, rgbcolor={
                0,0,255}));
        connect(Integrator1.outPortInterpolator, Interpolator1.inPortInterpolator)
          annotation (points=[36,34; 36,28; 72,28], style(color=1, rgbcolor={
                255,0,0}));
        connect(Integrator2.outPortInterpolator, Interpolator2.inPortInterpolator)
          annotation (points=[40,-44; 40,-52; 72,-52], style(color=1, rgbcolor=
                {255,0,0}));
      end TwoLoops;

      model Stairball
        output Real BallTrajectory;
        output Real BallTrajectoryDEVS;
        output Real Stairs;

        ModelicaDEVS.SourceBlocks.Step Step1(a=Modelica.Constants.g_n)
                           annotation (extent=[-132,100; -112,120]);
        ModelicaDEVS.FunctionBlocks.Add Add1(c1=-0.1)
                           annotation (extent=[-30,92; -10,112]);
        ModelicaDEVS.FunctionBlocks.Integrator Integrator1(method=world.qss, quantum=
              0.00001)                  annotation (extent=[18,92; 38,112]);
        ModelicaDEVS.FunctionBlocks.Integrator Integrator2(startX=10.5,
          method=world.qss,
          quantum=0.00001)              annotation (extent=[74,92; 94,112]);
        ModelicaDEVS.FunctionBlocks.Integrator Integrator3(quantum=0.00001, startX=0.5,
          method=world.qss)             annotation (extent=[-12,-90; 8,-70]);
        ModelicaDEVS.FunctionBlocks.Integrator Integrator4(quantum=0.00001, startX=0.575,
          method=world.qss)             annotation (extent=[32,-90; 52,-70]);
        ModelicaDEVS.FunctionBlocks.Add Add4(c0=1, c1=-1)
                          annotation (extent=[54,-44; 34,-24]);
        ModelicaDEVS.FunctionBlocks.Quantiser Quantiser1(quantum=1)
                                      annotation (extent=[100,-60; 80,-40]);
        ModelicaDEVS.SourceBlocks.Step Step2(a=10)
                           annotation (extent=[138,-30; 118,-10]);
        ModelicaDEVS.FunctionBlocks.Add Add5(c1=-100000)
                          annotation (extent=[0,28; -20,48]);
        ModelicaDEVS.FunctionBlocks.Comparator Comparator1(Vl=0, Vu=1)
                                         annotation (extent=[-78,-18; -54,6],
            rotation=90);
        ModelicaDEVS.FunctionBlocks.Multiplier Multiplier1
                                         annotation (extent=[-50,32; -70,52]);
        annotation (Diagram(
            Text(
              extent=[-84,116; -102,116],
              style(color=10, rgbcolor={95,95,95}),
              string="g=9.8"),
            Text(
              extent=[30,-28; -14,-28],
              style(color=10, rgbcolor={95,95,95}),
              string="height of stairs"),
            Text(
              extent=[-68,114; -86,116],
              style(color=10, rgbcolor={95,95,95}),
              string="-"),
            Text(
              extent=[-68,98; -86,98],
              style(color=10, rgbcolor={95,95,95}),
              string="-"),
            Text(
              extent=[68,-42; 50,-42],
              style(color=10, rgbcolor={95,95,95}),
              string="-"),
            Text(
              extent=[68,-24; 50,-26],
              style(color=10, rgbcolor={95,95,95}),
              string="+"),
            Text(
              extent=[-16,-74; -34,-74],
              style(color=10, rgbcolor={95,95,95}),
              string="x''"),
            Text(
              extent=[30,-74; 8,-74],
              style(color=10, rgbcolor={95,95,95}),
              string="x'"),
            Text(
              extent=[72,-74; 52,-74],
              style(color=10, rgbcolor={95,95,95}),
              string="x"),
            Text(
              extent=[-62,-70; -80,-70],
              style(color=10, rgbcolor={95,95,95}),
              string="-0.1"),
            Text(
              extent=[110,108; 90,108],
              style(color=10, rgbcolor={95,95,95}),
              string="y"),
            Text(
              extent=[68,108; 48,110],
              style(color=10, rgbcolor={95,95,95}),
              string="y'=vy"),
            Text(
              extent=[14,108; -6,108],
              style(color=10, rgbcolor={95,95,95}),
              string="y''=v'y"),
            Text(
              extent=[-50,16; -70,16],
              style(color=10, rgbcolor={95,95,95}),
              string="sw"),
            Text(
              extent=[120,-14; 62,-14],
              style(color=10, rgbcolor={95,95,95}),
              string="height of first step"),
            Text(
              extent=[70,68; 12,68],
              style(color=10, rgbcolor={95,95,95}),
              string="b/m*vy + k/m*y"),
            Text(
              extent=[26,58; -38,58],
              style(color=10, rgbcolor={95,95,95}),
              string="Add3 - k/m*int(h+1-x)"),
            Text(
              extent=[-26,92; -44,92],
              style(color=10, rgbcolor={95,95,95}),
              string="-0.1"),
            Text(
              extent=[-24,110; -42,112],
              style(color=10, rgbcolor={95,95,95}),
              string="+"),
            Text(
              extent=[-18,-56; -76,-56],
              style(color=10, rgbcolor={95,95,95}),
              string="-ba/m*vx")),
          Coordsys(extent=[-140,-120; 140,140]),
          experiment(StopTime=7, Algorithm="Lsodar"),
          experimentSetupOutput(
            states=false,
            derivatives=false,
            inputs=false,
            auxiliaries=false),
          Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Bouncing Ball</b></font>
<br/>
<br/>
This example is taken from the PowerDEVS software. It simulates a ball bouncing down a stair.
<br/>
<br/>
The model represents the following equations:
<center>
dx/dt=v<sub>x</sub><br/>
dv<sub>x</sub>/dt= -b<sub>a</sub>/m*v<sub>x</sub><br/>
dy/dt=v<sub>y</sub><br/>
dv<sub>y</sub>/dt=-g-b<sub>a</sub>/m*v<sub>y</sub>-s<sub>w</sub>*[b/m*v<sub>y</sub>+k/m*(y-int(h+1-x))]<br/>
</center>
<br/>
where x and y are the horizontal and vertical position of the ball, respectively, s<sub>w</sub> is equal to 0 if the ball is in the air, and 0 if it touches the floor, b<sub>a</sub> is the air friction constant, k is the spring constant, and b is a damping constant. The function int(h+1-x) gives the height of the floor at a given position. Note that h is the height of the first (top) step, and we assume steps of 1m by 1m height and length.
<br/>
<br/>
The current ModelicaDEVS stairball model features the following parameters: m=1, b<sub>a</sub>=0.1, k=100000, b=30, and the initial conditions: x(0)=0.575, v<sub>x</sub>(0)=0.5, y(0)=10.5, v<sub>y</sub>=0.
<br/>
<br/>
<br/>

<font color=\"#FF0000\"><b>Output:</b></font>
<br/>
<br/>
There are three output variables present: BallTrajectory, BallTrajectoryDEVS and Stairs. The Stairs variable represents the stairs, or in other words, it gives the current height of the stairs. The BallTrajectoryDEVS variable shows the actual DEVS simulation output, and the BallTrajectory is the interpolated version of BallTrajectoryDEVS.

</html>"));
        ModelicaDEVS.FunctionBlocks.Add Add2(c0=-1, c1=-1)
                           annotation (extent=[-74,96; -54,116]);
        ModelicaDEVS.FunctionBlocks.Multiplier Multiplier2
                                         annotation (extent=[-56,-90; -36,-70]);
        ModelicaDEVS.FunctionBlocks.Add Add3(c0=30, c1=100000)
                                             annotation (extent=[50,36; 30,56]);
        ModelicaDEVS.SourceBlocks.Constant Constant1(v=-0.1)
                                             annotation (extent=[-106,-86; -86,
              -66]);
        ModelicaDEVS.SinkBlocks.Interpolator Interpolator1(method=2)
          annotation (extent=[120,66; 140,86]);
        inner ModelicaDEVS.Miscellaneous.worldModel world(qss=3)
          annotation (extent=[-140,6; -120,26]);

      equation
        BallTrajectory=Interpolator1.outPort;
        BallTrajectoryDEVS=Integrator2.outPort.signal[1];
        Stairs=Add4.outPort.signal[1];
        connect(Step1.outPort, Add2.inPort1)
          annotation (points=[-110,110; -76,110],
                                               style(color=3, rgbcolor={0,0,255}));
        connect(Add2.outPort, Add1.inPort1)
          annotation (points=[-52,106; -32,106],
                                               style(color=3, rgbcolor={0,0,255}));
        connect(Add1.outPort, Integrator1.inPort)
          annotation (points=[-8,102; 16,102], style(color=3, rgbcolor={0,0,255}));
        connect(Add3.outPort, Add5.inPort1)
          annotation (points=[28,46; 16,46; 16,42; 2,42],
                                            style(color=3, rgbcolor={0,0,255}));
        connect(Add5.outPort, Multiplier1.inPort1)      annotation (points=[-22,38;
              -30,38; -30,46; -48,46], style(color=3, rgbcolor={0,0,255}));
        connect(Comparator1.outPort, Multiplier1.inPort2) annotation (points=[-66,8.4;
              -66,26; -34,26; -34,38; -48,38], style(color=3, rgbcolor={0,0,255}));
        connect(Multiplier1.outPort, Add2.inPort2) annotation (points=[-72,42;
              -106,42; -106,102; -76,102],
                               style(color=3, rgbcolor={0,0,255}));
        connect(Multiplier2.outPort, Integrator3.inPort)      annotation (points=[-34,-80;
              -14,-80],        style(color=3, rgbcolor={0,0,255}));
        connect(Constant1.outPort, Multiplier2.inPort1)
          annotation (points=[-84,-76; -58,-76], style(color=3, rgbcolor={0,0,255}));
        connect(Integrator3.outPort, Integrator4.inPort)
          annotation (points=[10,-80; 30,-80],  style(color=3, rgbcolor={0,0,255}));
        connect(Integrator3.outPort, Multiplier2.inPort2)      annotation (points=[10,-80;
              16,-80; 16,-102; -70,-102; -70,-84; -58,-84],    style(color=3,
              rgbcolor={0,0,255}));
        connect(Integrator4.outPort, Quantiser1.inPort)           annotation (points=[54,-80;
              114,-80; 114,-50; 102,-50],         style(color=3, rgbcolor={0,0,255}));
        connect(Step2.outPort, Add4.inPort1)      annotation (points=[116,-20;
              64,-20; 64,-30; 56,-30],
                               style(color=3, rgbcolor={0,0,255}));
        connect(Quantiser1.outPort, Add4.inPort2)           annotation (points=[78,-50;
              64,-50; 64,-38; 56,-38],      style(color=3, rgbcolor={0,0,255}));
        connect(Integrator1.outPort, Integrator2.inPort)
          annotation (points=[40,102; 72,102], style(color=3, rgbcolor={0,0,255}));
        connect(Integrator1.outPort, Add1.inPort2)      annotation (points=[40,102;
              64,102; 64,82; -48,82; -48,98; -32,98],
                                                  style(color=3, rgbcolor={0,0,255}));
        connect(Integrator1.outPort, Add3.inPort1)      annotation (points=[40,102;
              64,102; 64,50; 52,50],
                                 style(color=3, rgbcolor={0,0,255}));
        connect(Integrator2.outPort, Add3.inPort2)      annotation (points=[96,102;
              104,102; 104,42; 52,42],
                                 style(color=3, rgbcolor={0,0,255}));
        connect(Add4.outPort, Add5.inPort2)           annotation (points=[32,-34;
              -16,-34; -16,16; 16,16; 16,34; 2,34],
                                                style(color=3, rgbcolor={0,0,255}));
        connect(Add4.outPort, Comparator1.inPort1)      annotation (points=[32,-34;
              -70.8,-34; -70.8,-20.4],             style(color=3, rgbcolor={0,0,255}));
        connect(Integrator2.outPort, Comparator1.inPort2)      annotation (points=[96,102;
              104,102; 104,6; -28,6; -28,-30; -61.2,-30; -61.2,-20.4],
                                                                  style(color=3,
              rgbcolor={0,0,255}));
        connect(Integrator2.outPortInterpolator, Interpolator1.inPortInterpolator)
          annotation (points=[84,90; 84,76; 118,76],style(color=1, rgbcolor={
                255,0,0}));
      end Stairball;
      annotation (Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Miscellaneous</b></font>
<br/>
<br/>
This package contains three more examples that were used during the development process of ModelicaDEVS to test the correctness of the library.
</html>"));
    end Miscellaneous;
    annotation (Documentation(info="<html>
<font color=\"#FF0000\" size=5><b>Examples</b></font>
<br/>
<br/>
In order to give a first idea about the modelling/simulation possibilities in ModelicaDEVS, several examples are provided in this package.
</html>"));
  end Examples;
end ModelicaDEVS;
