# ModelicaDEVS
A free library for discrete-event modeling using the DEVS formalism.(unlicensed)

## Library description

One of the most general approaches to discrete-event system modeling is Bernie Zeigler's DEVS formalism. A number of different tools have been created implementing that formalism to discrete-event modeling.

One of these tools is PowerDEVS, a tool developed by Ernesto Kofman at the University of Rosario (Argentina). PowerDEVS has been designed for physical system modeling, whereby the numerical integration algorithm is implemented as a Quantized State System (QSS) simulator using the DEVS formalism.

ModelicaDEVS offers a re-implementation of PowerDEVS within the Modelica framework.

### Library content
 1. `ModelicaDEVS.mo` file itself is usually put into the Dymola/work folder, or a subfolder
of it.
 2. Pictures: The `.png` and `.jpg` files in the Images-folder are used for the documentation of the components and packages in the ModelicaDEVS library. The folder Images should be put into the same directory as the ModelicaDEVS.mo file.
 3. C-function: A `.cpp` file used for the external C-function declaration in the Delay block. This file has to be put into the Dymola/Source folder.

## Current release

Download [ModelicaDEVS v1.0 (2007-09-27)](../../archive/1.0.zip)

## License

**The license state of this library is unclear since the authors did not specify any license. Please contact the authors in order to motivate them to clarify the license state of this library.**

## Development and contribution
ModelicaDEVS was realized by Tamara Beltrame in 2005/2006 as part of her MS Thesis research under supervision of [Prof. Fran&ccedil;ois Cellier](http://www.inf.ethz.ch/personal/fcellier/)
