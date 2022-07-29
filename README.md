# Logic Circuits Project 

The development of this project is part of the digital logic design course at the Polytechnic University of Milan, and as a final examination, it is necessary for the bachelor's degree in computer engineering. The course was held by prof. William Fornaciari in the academic year 2021-2022.<br>
***Final score: 30/30 cum laude***

## Project specification
<p><em>The complete specification and design of the solution are fully described in italian 
<a href="/deliveries/10686115.pdf">here</a>, a brief description follows.</em></p>

<p>The goal of the project is to implement a convolutional encoder with rate of transmission 0.5. It is therefore a question of specifying a hardware component, described in VHDL, which interfaces with a memory.</p>

<img src="/assets/CodificatoreConvoluzionale.jpg" style="width:210px;height:130px;margin-left: 10px;" align="right">
<p>The module is supplied with a continuous sequence of 8-bit words. Each word is then serialized, so as to generate a continuous 1-bit stream. Next, The convolutional encoding is applied to each bit, indicated in the image on the side.  The continuous flow in output is finally deserialized, resulting in 8-bit words. <br>
Since the bit rate at the encoder output is double the incoming one, for each word that is supplied, two will be obtained.
</p>

<pre>
<b><i>Example of execution</i></b>
  <code>
IN :  10100010
  
OUT:  11010001  11001101
  </code>
</pre>

## Tools used
- **Xilinx Vivado** - used for synthesis and analysis
- **Overleaf** - online LaTeX editor


