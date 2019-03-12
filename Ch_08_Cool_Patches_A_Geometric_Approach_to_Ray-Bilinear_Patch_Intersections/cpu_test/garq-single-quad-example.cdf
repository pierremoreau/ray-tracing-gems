(* Content-type: application/vnd.wolfram.cdf.text *)

(*** Wolfram CDF File ***)
(* http://www.wolfram.com/cdf *)

(* CreatedBy='Mathematica 11.3' *)

(***************************************************************************)
(*                                                                         *)
(*                                                                         *)
(*  Under the Wolfram FreeCDF terms of use, this file and its content are  *)
(*  bound by the Creative Commons BY-SA Attribution-ShareAlike license.    *)
(*                                                                         *)
(*        For additional information concerning CDF licensing, see:        *)
(*                                                                         *)
(*         www.wolfram.com/cdf/adopting-cdf/licensing-options.html         *)
(*                                                                         *)
(*                                                                         *)
(***************************************************************************)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[      1088,         20]
NotebookDataLength[    125193,       2493]
NotebookOptionsPosition[    124781,       2471]
NotebookOutlinePosition[    125157,       2487]
CellTagsIndexPosition[    125114,       2484]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell[TextData[{
 "Supplementary material for ray/patch intersection from the Chapter 8\
\[LineSeparator]in ",
 StyleBox["Ray Tracing Gems",
  FontWeight->"Bold"],
 " book (",
 StyleBox["http://www.realtimerendering.com/raytracinggems",
  FontSize->24,
  FontColor->RGBColor[0.5, 0, 0.5]],
 ")\n",
 StyleBox["\n",
  FontSize->14],
 StyleBox["Copyright (c) 2019 NVIDIA Corporation.  All rights reserved.\n\n\
NVIDIA Corporation and its licensors retain all intellectual property and \
proprietary\nrights in and to this software, related documentation and any \
modifications thereto.\nAny use, reproduction, disclosure or distribution of \
this software and related\ndocumentation without an express license agreement \
from NVIDIA Corporation is strictly\nprohibited.\n\nTO THE MAXIMUM EXTENT \
PERMITTED BY APPLICABLE LAW, THIS SOFTWARE IS PROVIDED *AS IS*\nAND NVIDIA \
AND ITS SUPPLIERS DISCLAIM ALL WARRANTIES, EITHER EXPRESS OR IMPLIED,\n\
INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND \
FITNESS FOR A\nPARTICULAR PURPOSE.  IN NO EVENT SHALL NVIDIA OR ITS SUPPLIERS \
BE LIABLE FOR ANY\nSPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES \
WHATSOEVER (INCLUDING, WITHOUT\nLIMITATION, DAMAGES FOR LOSS OF BUSINESS \
PROFITS, BUSINESS INTERRUPTION, LOSS OF\nBUSINESS INFORMATION, OR ANY OTHER \
PECUNIARY LOSS) ARISING OUT OF THE USE OF OR\nINABILITY TO USE THIS SOFTWARE, \
EVEN IF NVIDIA HAS BEEN ADVISED OF THE POSSIBILITY OF\nSUCH DAMAGES\n",
  FontSize->12,
  FontColor->GrayLevel[0]]
}], "Section",
 CellFrame->{{0, 0}, {2, 0}},
 CellChangeTimes->{{3.7597720017118807`*^9, 3.7597720797533164`*^9}, {
   3.7597721136061993`*^9, 3.7597721429452825`*^9}, {3.7597721781219044`*^9, 
   3.7597722199877806`*^9}, {3.759772251444661*^9, 3.759772262866501*^9}, {
   3.759772388684707*^9, 3.7597724157723026`*^9}, 3.7597724876845303`*^9, {
   3.7597725442424974`*^9, 3.7597725852426343`*^9}, {3.759772622263151*^9, 
   3.759772648404488*^9}, {3.7597727264337463`*^9, 3.759772737260614*^9}, {
   3.7597790100772333`*^9, 3.7597791726472287`*^9}, {3.7597792122038965`*^9, 
   3.75977921822367*^9}, 3.759779301245184*^9, {3.760309818560367*^9, 
   3.760309895764965*^9}, {3.760310119192481*^9, 3.76031012051786*^9}, {
   3.7603101599815474`*^9, 3.760310199396519*^9}, {3.760310230533825*^9, 
   3.760310261860712*^9}, {3.760310303913903*^9, 3.7603103052920074`*^9}, 
   3.7603104610067124`*^9, {3.760311066432551*^9, 3.760311066674826*^9}, {
   3.7603114744800396`*^9, 3.760311479437003*^9}, {3.7603115770319457`*^9, 
   3.7603116031882143`*^9}, {3.7604820076477065`*^9, 
   3.7604820697006574`*^9}, {3.7604821229231863`*^9, 3.7604822490417385`*^9}, 
   3.760482933951812*^9, {3.76048297445291*^9, 3.760482986967914*^9}, {
   3.760483107832075*^9, 3.7604831858551893`*^9}, {3.760483275133995*^9, 
   3.7604832768739*^9}},ExpressionUUID->"e0da43a8-4f78-4e93-a8b3-\
18765de35273"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{
    RowBox[{
    "This", " ", "is", " ", "a", " ", "numerical", " ", "example", " ", 
     "that", " ", "corresponds", " ", "to", " ", "the", " ", "accompanied", 
     " ", 
     RowBox[{"C", "++"}], " ", "code"}], ";", " ", 
    RowBox[{"see", " ", "also", " ", "Figure", " ", "8.4"}]}], " ", "*)"}], 
  "\[IndentingNewLine]", "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{
     RowBox[{"lerp", "[", 
      RowBox[{"p0_", ",", "p3_", ",", "t_"}], "]"}], " ", ":=", " ", 
     RowBox[{
      RowBox[{"p0", "*", 
       RowBox[{"(", 
        RowBox[{"1", "-", "t"}], ")"}]}], "+", 
      RowBox[{"p3", "*", "t"}]}]}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{
     RowBox[{"quadrilateral", "[", 
      RowBox[{"u_", ",", "v_", ",", "vertices_List"}], "]"}], " ", ":=", " ", 
     RowBox[{
      RowBox[{
       RowBox[{"(", 
        RowBox[{"1", "-", "u"}], ")"}], " ", 
       RowBox[{"(", 
        RowBox[{"1", "-", "v"}], ")"}], " ", 
       RowBox[{"vertices", "[", 
        RowBox[{"[", "1", "]"}], "]"}]}], " ", "+", " ", 
      RowBox[{"u", " ", 
       RowBox[{"(", 
        RowBox[{"1", "-", "v"}], ")"}], " ", 
       RowBox[{"vertices", "[", 
        RowBox[{"[", "2", "]"}], "]"}]}], " ", "+", " ", 
      RowBox[{"u", " ", "v", " ", 
       RowBox[{"vertices", "[", 
        RowBox[{"[", "3", "]"}], "]"}]}], " ", "+", " ", 
      RowBox[{
       RowBox[{"(", 
        RowBox[{"1", "-", "u"}], ")"}], " ", "v", " ", 
       RowBox[{"vertices", "[", 
        RowBox[{"[", "4", "]"}], "]"}]}]}]}], ";"}], "\[IndentingNewLine]", 
   "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"vertices", " ", "=", " ", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"0", ",", "0", ",", "1"}], "}"}], ",", 
       RowBox[{"{", 
        RowBox[{"1", ",", "0", ",", "0.5"}], "}"}], ",", 
       RowBox[{"{", 
        RowBox[{"1.2", ",", "1", ",", "0.8"}], "}"}], ",", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0.8", ",", "0.85"}], "}"}]}], "}"}]}], ";"}], 
   "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"u", " ", "=", " ", "0.6"}], ";", " ", 
    RowBox[{"v", " ", "=", " ", "0.4"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"rhit", " ", "=", " ", 
     RowBox[{"quadrilateral", "[", 
      RowBox[{"u", ",", "v", ",", "vertices"}], "]"}]}], ";"}], 
   "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"rd", " ", "=", " ", 
     RowBox[{"Normalize", "[", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"-", "3"}], ",", "4", ",", 
        RowBox[{"-", "12"}]}], "}"}], "]"}]}], ";"}], "  ", 
   RowBox[{"(*", " ", 
    RowBox[{"a", " ", "Pythagorean", " ", "quadruple"}], " ", "*)"}], 
   "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"ro", " ", "=", " ", 
     RowBox[{"rhit", " ", "-", " ", "rd"}]}], ";"}], "\[IndentingNewLine]", 
   "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"Clear", "[", 
     RowBox[{"u", ",", "v", ",", "t"}], "]"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"sol", " ", "=", " ", 
     RowBox[{"NSolve", "[", 
      RowBox[{
       RowBox[{"Thread", "[", 
        RowBox[{
         RowBox[{"quadrilateral", "[", 
          RowBox[{"u", ",", "v", ",", "vertices"}], "]"}], " ", "\[Equal]", 
         " ", 
         RowBox[{"ro", " ", "+", " ", 
          RowBox[{"t", " ", "rd"}]}]}], "]"}], ",", " ", 
       RowBox[{"{", 
        RowBox[{"u", ",", "v", ",", "t"}], "}"}], ",", " ", "Reals"}], 
      "]"}]}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"sol", " ", "=", " ", 
     RowBox[{"sol", "[", 
      RowBox[{"[", 
       RowBox[{"If", "[", 
        RowBox[{
         RowBox[{
          RowBox[{"0", " ", "\[LessEqual]", " ", 
           RowBox[{"(", 
            RowBox[{"t", "/.", 
             RowBox[{"sol", "[", 
              RowBox[{"[", "1", "]"}], "]"}]}], ")"}], " ", "\[LessEqual]", 
           " ", "1"}], " ", "&&", " ", 
          RowBox[{
           RowBox[{"(", 
            RowBox[{"t", "/.", 
             RowBox[{"sol", "[", 
              RowBox[{"[", "1", "]"}], "]"}]}], ")"}], " ", "<", " ", 
           RowBox[{"(", 
            RowBox[{"t", "/.", 
             RowBox[{"sol", "[", 
              RowBox[{"[", "2", "]"}], "]"}]}], ")"}]}]}], ",", " ", "1", ",",
          " ", "2"}], "]"}], "]"}], "]"}]}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"tx", " ", "=", " ", 
     RowBox[{"t", "/.", "sol"}]}], ";"}], "\[IndentingNewLine]", 
   "\[IndentingNewLine]", 
   RowBox[{"Print", "@", 
    RowBox[{"SetPrecision", "[", 
     RowBox[{
      RowBox[{"Join", "[", 
       RowBox[{"sol", ",", " ", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"rayorigin", " ", "\[Rule]", " ", "ro"}], ",", " ", 
          RowBox[{"raydirection", " ", "\[Rule]", " ", "rd"}], ",", " ", 
          RowBox[{"intersection", " ", "\[Rule]", " ", 
           RowBox[{"ro", " ", "+", " ", 
            RowBox[{"tx", " ", "*", " ", "rd"}]}]}]}], "}"}]}], "]"}], ",", 
      " ", "10"}], "]"}]}], "\[IndentingNewLine]", "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"scale", " ", "=", " ", "0.13"}], ";", " ", 
    RowBox[{"rscale", " ", "=", " ", "0.002"}], ";", " ", 
    RowBox[{"uvsplits", " ", "=", " ", "50"}], ";"}], " ", 
   "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"labelsg", "=", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"Graphics3D", "[", 
        RowBox[{"Table", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{"RGBColor", "[", 
             RowBox[{"0.2", ",", "0.6", ",", "0.6"}], "]"}], ",", 
            RowBox[{"Specularity", "[", 
             RowBox[{"Blue", ",", "10"}], "]"}], ",", 
            RowBox[{"Sphere", "[", 
             RowBox[{"n", ",", 
              RowBox[{"0.15", "*", "scale"}]}], "]"}]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"n", ",", "vertices"}], "}"}]}], "]"}], "]"}], ",", 
       RowBox[{"Graphics3D", "/@", 
        RowBox[{"MapIndexed", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"{", 
            RowBox[{"White", ",", 
             RowBox[{"Text", "[", 
              RowBox[{
               RowBox[{
                RowBox[{"{", 
                 RowBox[{
                 "\"\<00\>\"", ",", "\"\<10\>\"", ",", "\"\<11\>\"", ",", 
                  "\"\<01\>\""}], "}"}], "[", 
                RowBox[{"[", 
                 RowBox[{"#2", "[", 
                  RowBox[{"[", "1", "]"}], "]"}], "]"}], "]"}], ",", "#1", 
               ",", 
               RowBox[{"BaseStyle", "\[Rule]", 
                RowBox[{"{", 
                 RowBox[{
                  RowBox[{"FontFamily", "\[Rule]", "\"\<Arial\>\""}], ",", 
                  RowBox[{"FontSize", "\[Rule]", "14"}], ",", 
                  RowBox[{"TextAlignment", "\[Rule]", "Center"}]}], "}"}]}]}],
               "]"}]}], "}"}], "&"}], ",", "vertices"}], "]"}]}]}], "}"}]}], 
    ";"}], "\[IndentingNewLine]", "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"grst", " ", "=", " ", 
     RowBox[{"ParametricPlot3D", "[", 
      RowBox[{
       RowBox[{"quadrilateral", "[", 
        RowBox[{"u", ",", "v", ",", " ", "vertices"}], "]"}], ",", " ", 
       RowBox[{"{", 
        RowBox[{"u", ",", "0", ",", "1"}], "}"}], ",", " ", 
       RowBox[{"{", 
        RowBox[{"v", ",", "0", ",", "1"}], "}"}], " ", 
       RowBox[{"(*", 
        RowBox[{",", 
         RowBox[{"Mesh", "\[Rule]", "30"}]}], " ", "*)"}], " ", ",", 
       RowBox[{"Mesh", "\[Rule]", " ", "9"}], ",", 
       RowBox[{"MeshStyle", "\[Rule]", 
        RowBox[{"(", 
         RowBox[{
          RowBox[{
           RowBox[{"Directive", "[", 
            RowBox[{
             RowBox[{"Thickness", "[", "0.0003", "]"}], ",", "#"}], "]"}], 
           "&"}], "/@", 
          RowBox[{"{", 
           RowBox[{"Blue", ",", "Red"}], "}"}]}], ")"}]}], ",", 
       RowBox[{"PlotStyle", "\[Rule]", 
        RowBox[{"Directive", "[", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"Opacity", "[", "0.5", "]"}], ",", "Cyan"}], "}"}], 
         "]"}]}], ",", 
       RowBox[{"ColorFunction", "\[Rule]", "\"\<LightTerrain\>\""}]}], 
      "]"}]}], ";"}], "\[IndentingNewLine]", "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"gvertices", " ", "=", " ", 
     RowBox[{"Graphics3D", "[", 
      RowBox[{"{", 
       RowBox[{"Gray", ",", 
        RowBox[{"Thickness", "[", "0.002", "]"}], ",", 
        RowBox[{"Opacity", "[", "1", "]"}], ",", 
        RowBox[{"Line", "[", 
         RowBox[{"Append", "[", 
          RowBox[{"vertices", ",", 
           RowBox[{"First", "@", "vertices"}]}], "]"}], "]"}]}], "}"}], 
      "]"}]}], ";"}], "\[IndentingNewLine]", "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"grays", "=", 
     RowBox[{"Graphics3D", "[", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"RGBColor", "[", 
         RowBox[{"1.", ",", "1", ",", "0.5"}], "]"}], ",", 
        RowBox[{"Arrowheads", "[", 
         RowBox[{"10", "*", "rscale"}], "]"}], ",", 
        RowBox[{"Arrow", "[", 
         RowBox[{
          RowBox[{"Tube", "[", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{"ro", " ", ",", 
              RowBox[{"ro", " ", "+", " ", 
               RowBox[{"tx", "*", "rd"}]}]}], "}"}], ",", 
            RowBox[{"Scaled", "[", "rscale", "]"}]}], "]"}], ",", 
          RowBox[{"0", "*", "rscale"}]}], "]"}], " ", ",", 
        RowBox[{"Specularity", "[", 
         RowBox[{"White", ",", "50"}], "]"}], ",", "Cyan", ",", 
        RowBox[{"Sphere", "[", 
         RowBox[{"ro", " ", ",", 
          RowBox[{"Scaled", "[", 
           RowBox[{"2", "*", "rscale"}], "]"}]}], "]"}], ",", " ", 
        RowBox[{"Darker", "@", "Red"}], ",", 
        RowBox[{"Sphere", "[", 
         RowBox[{
          RowBox[{"ro", "  ", "+", " ", 
           RowBox[{"tx", " ", "*", " ", "rd"}]}], ",", 
          RowBox[{"Scaled", "[", 
           RowBox[{"2", "*", "rscale"}], "]"}]}], "]"}]}], "}"}], "]"}]}], 
    ";"}], "\[IndentingNewLine]", "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"gn", " ", "=", " ", 
     RowBox[{"Show", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"labelsg", ",", "gvertices", ",", "grst", ",", "grays"}], 
        "}"}], ",", 
       RowBox[{"ImageSize", "\[Rule]", "800"}], ",", " ", 
       RowBox[{"PlotRange", "\[Rule]", "All"}], ",", 
       RowBox[{"AxesStyle", "\[Rule]", 
        RowBox[{"Directive", "[", 
         RowBox[{"Bold", ",", "12"}], "]"}]}], ",", 
       RowBox[{"PlotStyle", "\[Rule]", " ", 
        RowBox[{"Specularity", "[", 
         RowBox[{"White", ",", "500"}], "]"}]}], ",", " ", 
       RowBox[{"AxesLabel", "\[Rule]", " ", "None"}], ",", " ", 
       RowBox[{"Axes", "\[Rule]", " ", "All"}], ",", " ", 
       RowBox[{"Boxed", " ", "\[Rule]", " ", "False"}], ",", 
       RowBox[{"Lighting", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"\"\<Point\>\"", ",", "Orange", ",", 
            RowBox[{"{", 
             RowBox[{"1", ",", "1", ",", "1"}], "}"}]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"\"\<Point\>\"", ",", "White", ",", 
            RowBox[{"{", 
             RowBox[{
              RowBox[{"-", "4"}], ",", 
              RowBox[{"-", "4"}], ",", "4"}], "}"}]}], "}"}]}], "}"}]}]}], 
      "]"}]}], ";"}], "\[IndentingNewLine]", 
   RowBox[{"gn", "//", "Print"}], "\[IndentingNewLine]"}]}]], "Input",
 CellChangeTimes->{{3.7597720017118807`*^9, 3.7597720797533164`*^9}, {
   3.7597721136061993`*^9, 3.7597721429452825`*^9}, {3.7597721781219044`*^9, 
   3.7597722199877806`*^9}, {3.759772251444661*^9, 3.759772262866501*^9}, {
   3.759772388684707*^9, 3.7597724157723026`*^9}, 3.7597724876845303`*^9, {
   3.7597725442424974`*^9, 3.7597725852426343`*^9}, {3.759772622263151*^9, 
   3.759772648404488*^9}, {3.7597727264337463`*^9, 3.759772737260614*^9}, {
   3.7597790100772333`*^9, 3.7597791726472287`*^9}, {3.7597792122038965`*^9, 
   3.75977921822367*^9}, 3.759779301245184*^9, {3.760309818560367*^9, 
   3.760309895764965*^9}, {3.760310119192481*^9, 3.76031012051786*^9}, {
   3.7603101599815474`*^9, 3.760310199396519*^9}, {3.760310230533825*^9, 
   3.760310261860712*^9}, {3.760310303913903*^9, 3.7603103052920074`*^9}, 
   3.7603104610067124`*^9, {3.760311066432551*^9, 3.760311066674826*^9}, 
   3.7603114744800396`*^9, {3.7603653426291*^9, 3.7603653487204795`*^9}, {
   3.7603653919063406`*^9, 3.7603654480174747`*^9}, 3.7604795922672367`*^9, {
   3.760479637994858*^9, 3.760479651097308*^9}, {3.7604822349220576`*^9, 
   3.7604822742081203`*^9}, {3.7604823105449033`*^9, 3.760482337570392*^9}, {
   3.7604824288559155`*^9, 3.7604824372202682`*^9}, {3.760484169588216*^9, 
   3.760484200765916*^9}, 3.760484289200433*^9},
 CellLabel->"In[15]:=",ExpressionUUID->"3bb15814-daa3-4a07-b10a-06019d2036f3"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   RowBox[{"u", "\[Rule]", "0.59999999999999997779553950749686919153`10."}], 
   ",", 
   RowBox[{"v", "\[Rule]", "0.40000000000000002220446049250313080847`10."}], 
   ",", 
   RowBox[{"t", "\[Rule]", "1.`10."}], ",", 
   RowBox[{"rayorigin", "\[Rule]", 
    RowBox[{"{", 
     RowBox[{
     "0.8787692307692307469579873213660903275`10.", ",", 
      "0.06030769230769228439470452940440736711`10.", ",", 
      "1.67107692307692312638778275868389755487`10."}], "}"}]}], ",", 
   RowBox[{"raydirection", "\[Rule]", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"-", "0.23076923076923076923076923076923076923`10."}], ",", 
      "0.30769230769230769230769230769230769231`10.", ",", 
      RowBox[{"-", "0.92307692307692307692307692307692307692`10."}]}], 
     "}"}]}], ",", 
   RowBox[{"intersection", "\[Rule]", 
    RowBox[{"{", 
     RowBox[{
     "0.64799999999999990940580119058722630143`10.", ",", 
      "0.36799999999999999378275106209912337363`10.", ",", 
      "0.74799999999999999822364316059974953532`10."}], "}"}]}]}], 
  "}"}]], "Print",
 CellChangeTimes->{3.760484511412568*^9, 3.760484678745857*^9},
 CellLabel->
  "During evaluation of \
In[15]:=",ExpressionUUID->"2b856025-571a-40de-b116-e3779473b123"],

Cell[BoxData[
 Graphics3DBox[{{
    {RGBColor[0.2, 0.6, 0.6], Specularity[
      RGBColor[0, 0, 1], 10], SphereBox[{0, 0, 1}, 0.0195]}, 
    {RGBColor[0.2, 0.6, 0.6], Specularity[
      RGBColor[0, 0, 1], 10], SphereBox[{1, 0, 0.5}, 0.0195]}, 
    {RGBColor[0.2, 0.6, 0.6], Specularity[
      RGBColor[0, 0, 1], 10], SphereBox[{1.2, 1, 0.8}, 0.0195]}, 
    {RGBColor[0.2, 0.6, 0.6], Specularity[
      RGBColor[0, 0, 1], 10], SphereBox[{0, 0.8, 0.85}, 0.0195]}}, 
   {GrayLevel[1], Text3DBox[
     FormBox["\<\"00\"\>", StandardForm], {0, 0, 1},
     BaseStyle->{
      FontFamily -> "Arial", FontSize -> 14, TextAlignment -> Center}]}, 
   {GrayLevel[1], Text3DBox[
     FormBox["\<\"10\"\>", StandardForm], {1, 0, 0.5},
     BaseStyle->{
      FontFamily -> "Arial", FontSize -> 14, TextAlignment -> Center}]}, 
   {GrayLevel[1], Text3DBox[
     FormBox["\<\"11\"\>", StandardForm], {1.2, 1, 0.8},
     BaseStyle->{
      FontFamily -> "Arial", FontSize -> 14, TextAlignment -> Center}]}, 
   {GrayLevel[1], Text3DBox[
     FormBox["\<\"01\"\>", StandardForm], {0, 0.8, 0.85},
     BaseStyle->{
      FontFamily -> "Arial", FontSize -> 14, TextAlignment -> Center}]}, 
   {GrayLevel[0.5], Thickness[0.002], Opacity[1], 
    Line3DBox[{{0, 0, 1}, {1, 0, 0.5}, {1.2, 1, 0.8}, {0, 0.8, 0.85}, {0, 0, 
      1}}]}, GraphicsComplex3DBox[CompressedData["
1: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
WfiYlXSRb3YLNkeEPnWYVIH9tLJXRLdIr+v2IXGxXWGeUox2BUpD3nAMkhkI
LO1hTDbvwq7Yu/lE/99y2EMxvZOOa3nDm7aUUrFnPc/hhdUVSBY/biM/nY4j
aRNPyDyFYardkJFEJVZXUxKIDkX5IDiQE8HCPjBve5lV4uV9iZHJ5lRIvZ6p
wze7BwdzDy8meSmxa1jjglc3xoMlQrZe78NRncrEMU4lfAQqnZsSu9Bb/OBq
9rd+HC/dvpv4CALZbzO1OzrRrX7WOSyDG89fxkuI7m40lNK74UAPgiUCrqsm
2FGqt4mZdjhVoyS+qYroDTTnrLrQjBzoc2vUYpUaNK55MvXXCw6ajnzpJ7rc
jJayuAy/GphbO8iQeQFGEOcm8ctKTyT/nvtlxhiB6FrHfWxmEn7vxQl+Mq5X
i4s9yqZEv2p1GXlB9Dpdu9vCgdG1GFGYaU90qmg1zCX6rNDPi9eIvuJypu8+
0ZNYSjd++2iFbqYDzafqIPjqy2tyjrIr8n7reB7CW06QvLlPf/PbrzmxRJBB
6uh2P4U64iPMW36nnehHofN3rSb74l8wZ+dHl3oEnrAcyxekoW3mPTui7+WE
/kwzba3H8rDtYp67ubz2lmUL0ZlvyFMVib8Q0yGzhvCplZPu8MRoD0Ar7kso
8V1VFvPqCtV1/Xf+dviv+dv/zOs6/zWva/JnLvfCP+Zymf+PuVyLv+Zym/4x
l2v0Zy736V9zuX/3Kev/zOVu/8dcbuY/5nLV/8zlTlz6v3O5cX/mcp/8NZer
8I+53Jd/5nJL/prLXfjXXG5lnr4VqXOmelvnZG1tQ9fRpXOXPuHgm9a2jnuX
7SmyWbYMosOpLdi0k+h8hXo3swhe32+as0mpog33Xgq0e8/kIELDTJfgy7H4
wYSy1e1QZzJfk7mmLbMDz5J8GBtt/N3vdK/6Yk/0zLVTp70n9/dQK6eD8rEd
Pjaxm4huKT1xeZist9rzzSWHSR3QSPITJvrk7dGhhQTnCkv9ppO4po051BId
0vXb600dTt0wn3v1t6/xYJNpCJn/cew/dpzogT8PnlAn/dbGW5rnLh9nwJot
7k709sehur/9CMbnxardzXRY0sqiiM6oxFx30susE74ifJP3mNBh1uFeTPTB
IsWFYznceksxpJeklNGwslfqO8Hh4w78v30Kpn+Rv4wODZFnnQRvsQfwK61n
OeE1j5rfmt/PpqLo7hYq4RlHPYaeWWt2Ql5sf9RjVQ6CayR8U5vsKZa/9ccO
nNez4a8L40At6aQKqZf7yuYuPnSfu88WzV3Eb/OKWuFE8H33PLWXBI/Cw5f2
krmXgZLhVoJH246a/vYvzK2mPqgZ5PbRefU8Idz82Rh5NVrqVhek1vetfeTO
wtb0VGly32v7ApVIvjX/rK41kuDykIN6ob/3p5oVT3yTJ7mpl+fEMFGyD7/9
wSXXu9TIeZt4BUuS+ZYlRkq5PrZ0iBfwfyLxNMvInQtnDFzSX1JDePeMGXJa
hGeULzhnbniagRLdWTQylyGwb2demDUV3l0G/LN/cbFRh/c78Q1/BZ7TIee1
841qVKUPHR+lR90Yff34Rrv3hfiLArYLd/nK0NEdbONlrTkI9ur3v32QXA3e
XjIPkWWgcngJl589oOe+Jfu1LfHaQPzEnaf7N9M0HSiUQMsNZP8vXV9mkvt+
tUj7DeEZNKUlixerULF5nn0i0aFtxIYiSV3UcHL2zfCjQtT88BoyNxLovmcv
wfH7OQ18xJdpi94WTfTlyTfC9QnudE9TuUT87Jjvq37r1aecx/RInqia+DJf
RNNwdbNYKNGlLdKilpN79QrqPUjiVNd7XJLoz+KpVcvIPtoZO0ubT9EhUU/z
J/FalDQuQ+J0nXLkJsIvmNJlswg/dE5YIUPmyDyv8H4gvkayVZI3wXnFD0ZL
CW9qyT267KMLA57JQYJ1YQx0xl6XVqrog7JImj/x1Yx5Pd2IH7pzX43o6IYB
3NonLkT8Dhk963HiZ0vXnhE9dH8QjcF2V8k+vj7Zf5n498nzVtQQvpur/TiD
3H/qjaxSZwc2vv3MG5oZ7ECZ9WviCHmuxvjaK3Ni2JjvKbc4k8vb7H1XLibP
8Uw/egmdwobC5lYW4RmyLdkuqtsZuCrlb0d8+V2bovJIXayXPdBB6s9hjmtB
ShkLZyg2wQTH79j0abWKM6GZek5i6RMWtkkFfiK4s/HTrdA1N5iQ8txn5WXG
gtFC3jckT3qmSPKS8x033sy9dxZOSFo+IfcatDfuOPFr2pau+u372y74covs
Q//FjlzSZ2UOzLMoTGHCTULZlsz/TWa0ypC6F5wxOYWs4zff30z2TQ/ile1v
ER/UxbtH+NlOJgymjUeUre7HSWdhGuHR5gfrj/DNZqLhbuwLYc8BzCsM2U7m
SDavyHlPdMijwscfancMonCWWiTpg5Z+f8tH7is7cdGbl3UvEKy8UcQ4OB5X
lUpfET0uwPKomURCGUxWVVqvTUmAjf5ec/oYG0+eH5Cl3KyGnwIfvVKM21/w
r/j2aoCFT6/Pukdt6oDO8gCd94pJ+Ljs7duBSjq6/ujw7n/p8Ks95H+sAQMT
i5Wi7+9IRty2NRbq8d0wvJJhJ/SQhY2LzKUVI5LBNzblx9irLgQeZ579qNmH
hAX5IuePpSDqZIKU66MOXHVuWn3eKgbNxfXeBXm52LFj/3z9ndz+IWFQ2Xth
Fi6UN0w6tTQP0S5rbp4y7UGmUsKmEdFKPGpoYoa3cuNloOvAYyc28hcYziF9
pVxr8+FtG/NRv+JT7ts7LJQIDNBX+DUhrbOlovtpPjaaP1bMC2Di3PnHBW/v
dKKL3Zay1LgAfFU7+L+m0tF7/OQaDTa3P+pvX5UTVwBLYWlr4WIaLv7R54X+
0ue/6vH+9lNe/OicO/l8IZSuVm/7/fmtlefbpnHrxXjX7ZDiQvjFv401IP+e
QD2knvShuZOpv4je/p3jvuC0cBc+zVNb8tOiHyZTaBfb3T/j0DIzd5cFnTCC
b44W7330vvl1zLK6FO22NYMvT/TCLvHlRjXeMvCePPS1cWM5tCIsPzK72Fg4
dfeFsosdmHN5tV6KcQXEH9blB3gzkN5z6pJPIgNLBL1mmslVwin/zP22aTQE
/tGrl/2lVx+pvHHdYKwPq/2Z1QJjlWga+bVPxovb59SvUM+Li8SsExsqp3+o
xsLI0a4lL3ugFhNdyvc0A5XspdveitbgJbV+vJPBgdu0JN1Z+RXQG/sqzymu
wQfzR+tO2rAx/nNjA9Gdp7u1vLi7ohYbQmz3LE9iQfXUKTRmd0JHwn/49OY6
VB4SCT59iwG7o69/65+CoddPTw2ug+kzTqp8ER19e5RmJcmzcOu9/p4dB+th
Kf6qn+g4K3fY7n8TysFWdfVsenI9+k08hM8/oeLMH716ctb/1asNn18dJLpN
1g6hqOV2DeCp3qJF/IzKf/DMvf/gk5/+8EnGX3zy4R8+eewPn7T8wycL/+KT
k/7wyXH8Xz75n3/nte4fvLH0/8Eb1f7ijXz/4I2B/+CNz//BGy3/wRvtjBVM
9c2DcT7fzOxafyveqZRO6uLGg7Pu/SYbywrwqTIHqDvb8Z7P0XypMRvnNv9a
THyLIOcKj4UP2nFI5+Cqe6UsSPmGjbwa6MQ5gzs6ucc7cGQe/71SDSb43QrN
0oNYUF+2RfisSifMqDG9IpF0jDtfd5NQ7EHVWYWQ0KudEJb3Tbm8mI7hFIcT
zOUDEPgxVjJzaheOfdi/Z89sGvwfHPy17m0sHs4y1BNZ1Ylgo8NLNHdzsCj1
YnZjdjbumtpX/rjWiUOSW3J/trNxovTnS+IDXmalNJZLd6H2jYjQVUE2phe0
5n/hbYC1cvORNLsu+Np+jd7wnIXkjExGj3orLJ3GOyPzu6C/oXHPmCIL7vs3
i80z5PIkoS3sa2e6UVQU/shpHxPNRmtlZXtp2L335AWi33r43lXTYDNwc/dc
HeJraXS+uqRlRgWP9L5rKbMYaNIRMN2X0Qtl+ZKxlXFUpDM3LrkcweVbYVcS
1r7txwqb3utEF3V6L52rpkHH5iVfP30cHcDiVFE+PhMa1C4Lnhr5QsMsRsbS
RSM+cN0ekxzg3Q2e75U2fuIcxPRr9swfKcc16ZwZlyOosKq72/Xb3+rbOSQ5
rwvl2usahiXpiJq8qozov2qM4n5LYTZKluoo1axnYG4XFcSfiLRefqnx+gA+
Txz2+KDHxI2cwFjin9lbnlxyo/sVdHwyT17QoeOY0q/ZqV5sHDDp0eTZkoWx
RpP87Dg6tMbpFiROzkbeqT56tgpHrN08CC7wBnyaNkxl4W640bs95fUQ/Tif
kdbLQPepqKNHY1j4tqch6P71bsg8a55KcMK9wnL/syks8O2heBMdvYZqc4bU
K4sgwzd85UxI7xa0/P6Yy6+vBCm8t2BDdsMKgzozJpR1rYwv6PSBlbfei6+c
DcGpc15uWsGEXPiCJ4r7BqF30Hw3wZuil0yd2ancfT0Rtkk+lg8JxeBRv4MJ
WPzsSpmMQA+6brpJ9a1qQPkKlcM2dokQ+zjhcY7OxGqrt3OJXj1NzrJqZmUi
TlvXSii2MDDV75HzARYV2dLj6/tZSTDzMa1ySKfC8YJRP8FXx4UPn5TypsAk
tvVuehC3D3AsOLxEvh369NZtN7/nIzjgQkDza25fP54ycmZzEoYTaPfqzMpg
rPh+/cz7Pfja6NKssjcP4xllH7f3lKGE5eXonMJBqorDtRfKDZh2YduSnZ/L
sWrhYq1sNRacZDxXSwm3QvRrSpLrjAqE1o+5rT7O5U0TxgUzWrsgPh7a3f+s
Avf2fJg6JZmO1uEji/R30iDpNu+KXGcFeIXv69p20nCt6bIsWV9+lj2lLL4S
JzSl5yYf64aomrmLYfRn+NhOS9Y9X4OVMknzib47el7mB8GLO74xbkXdtdgp
pXSL+A5x+3qKSXzkr7BsJj5je0NRDfHTbf74WSF/+VkSbzevtPcrxNl+nkMx
fO0QyHzon9zExiG1sxbEP1XLTVloXNcOwXuUkRFtFpb7c2p2m7ejUij0g9fC
DsRVLsk5nsWEiOdMirkoA8GtpvZr+zsQH1y89OUqBoYdVSIc0vtgFTdbldSx
xPP2N4n+bvvHb7rxx2+a/8dvWnPIgH9KMhfXshef8hPvxnTezMHUHCYe0rWz
Ze1SUHNfSIHwiTKtjz2R+Wz4scpaCF+Rb7B40bCDikCvMEvye2b/8UEq//JB
HOlMJuE/yxOufCX+i5DVoQaix58fWPR1v3U7rozXWezLoKExaasR8TmqOPaD
7Z+okHngs+uxEx2Ou+fuJDr5LVbwwMsT3L65kfNpfT0d25/8yiX+XOmAzyXH
lf2wT5w0d84AA3GOieuJf/x0r+tQ27QSRC/rWS4mycDSksoUr4VsvP7jX2T/
8S/y/vgXVH27uHlfOrg8dfsrcr7hvNf4lcHCbL0wp+vdTHgoTS0+/IsFbSvK
uNUTJtKmSK1wfVSFHoVRy/l8iVhw5cRF5nL2f+dG/uarXbEh395IsvB40f6X
9n7JOGi9xX5DWxdOeCVczghKxaT1EQJff+UimVdr+ZHUHhySyxor/V4FPvsZ
VHG+fJw+X50UJMHGT6Gzd9KDGsE/d6uRgkc+spcGumQWcfsJy7aq0u9dEDR+
q6zvXQC7e2tmTVb431zHf3jjlz+8MWPnbXNSv4Qfic0k8bjsR27Ylrvc+N/Y
uiJxqAfT1+9y8RD7jOsx986d2ND137mC//C0/j88zc5D6wiZvxFVzS4Y+lUN
T1z+YSzSg4DTU0LOpFXDe75EmDhfLfiN47dOm8xGwOjzS6Su7OhZyNnjXQfK
N68EgsOO1/Zv7ApnI7fMvsDOrx6pQoU8Rl3/8/f/5kv/mdc1/ce8ruo/5nVn
/2Net/+ved3/zOW+/sdcrvtfc7lGf+Zyj/9jLnfTn7ncb3/mchte794u4FoD
3Y21p2e5tSN4w8MKRyYLa+JkxQSjOXCVV3LzP9+JPZLFh09soGO6y+yEBYqf
8M16nep68v+5PN2dqMPl95eL+8WNumogWj1qT3zn3tV84ootLChn5cdwARzP
+Y882pbYhZzLbYUh27j9pol6jyH3XJMsZarDn3Xj/IzH8h5iTEzXnfGbt1QU
s377vPPDdb3O0elwWPqLdu1MP4782q2cOERFX5+sZtseOhZeCXq6aX06NCfO
zic+8eyaW7e1zNhInqaa3hdZi8e8W+89y2Xgztzul89yWShjDPsQ31RcyPMT
yX8Nh4EvpF7nX289hPW9uChipkzuPyZxD/MqmLBj/zgTLVmEk6vjhwVcE+AQ
y1cX/ozLb+dnSJK5DYcVm5oUPBKRvS1XeFUcE+3/8KE6ZSuuiDXQICI9S/m4
aDISwrsavxtS0aVuc0HLrAdSCwPFPMVSMGlD2IzrZzpR+sdnEfjLZ+HcHmNX
SH+Er8Hc4p6rZQhe0jLD9EQPLikc16mQLsbpz6uSybxQdJbolP3qXJ70U2yk
XLoJkUJ2h82o5cie5PjNsIuJT//wFw6tSQ+XNO0GbVfq5J+vKlCv1da1x5uO
n3f8U4k/7X7ucI3OtEpQO2Y17Tbn4itlZ7e8Ry/y3oY5UcsrMbbE6bPOtG44
Fvsnd4UXY4/c+fUkvrYXiS1aI8jBm3/o7bfTRhuWr+HGc+vnA+ai9fh5Xb7J
kfm/eYzQP/XL9E/9chKe5C8YXYIZtt/9cxe3w7lJeg+5t69lElqC0c24w5+w
gcxpZD/j/43nnv/QRV8uyhIncbf1mMF7nWmdWJl2oKn0Ox1m0gW3cxf3I2NI
xJjUKZurG9t/XKPh6l/16z/zEg7/0AO5rEV2ddwnSKjpRw396sbKJGbQNm4f
dG3XGftVcV8wXKE6l8T5B87q64+2sCH+j/p1Mc5GclVcC97xT+mT96AhZ1+K
5vojLJz4hz72YJF4Rsg2GizVawvJ/VVlb/lZ7ci99xse+4gfv7Xq03pStw+O
eDbJCDBxV2btVvX4fvwS8J5BzuPc8dkBuYsZcGEHdmN9Kc5Mqq8i96P/bZ3/
+Vns//rvWX/574b/0JF2xbMc/M+zsG3a10vk83aPg5v2eDPx/wF6YPj4
    "], {{
      {RGBColor[0, 1, 1], AbsoluteThickness[2], Opacity[0.5], EdgeForm[None], 
       Specularity[
        GrayLevel[1], 3], 
       StyleBox[GraphicsGroup3DBox[
         TagBox[{Polygon3DBox[CompressedData["
1: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
Wzn7LFc1he6r3uF/KtgoXg==
            "]], Polygon3DBox[CompressedData["
1:eJwtmXXcVtUShfceFAQBBQyQBkEkvAgiXaLiVTEwMRE7EcXkGih2o6IiInZ3
N2J3B3Z3t2Lc9bjmj/l9s97zxjl7z6y1Zn+dJ00ev0+UUubWUhbT3yME2jco
Zarw08IbC/cTXlv4SOGjhDsIHyj8nPAg4SbCg4R3FT5a+GflBymeF15c13ro
tXWUX6vXhipfUq8NVr6nXhsl3Fx4mPBk4eHCTYWHCO8lPFK4mfBQ4X2EZwi/
qnhR+QuKRsr/VLTQ9ZWExynvq/ePEf6f8G/6e6jiNeWPKzbS9VV1fS29doTw
QOHGwgOFdxH+RX8PVrys/BHFr8oPUbyi/FHFYnrvCvpML+Xn6/UTFE0UzYXb
K6bpWju9Z0r17/G8Vyu2Vr6NYlvly+n65rp+vvAQ4asUE5RvlfdzuWJz5Vso
tlO+vN6/hd4/R3gn4TbCWwtfLBzCHYX/Ut5KsYNwa+EJun6h8CTh15VvpZgn
vJrwpYpNlG+qmK7X/9BffaS0VOysaysIbKPXLxGeILys8KbC5wr3Er5Qsa7y
9RR9lV+s2JC1Veyv/Eu9d2/FfOFuwnMUaypfq7gWLlCMLa6Jt/W+7RVXF68H
+32dYjvl2yve1LVtFVcU//5byrdTXKn8PMVmeu8yur/xeu1M4d/1d5rideVP
UK/K/yyubdZnhnBRNNKf5RSLlB+meLO43rleFcsqb6g4VvniitbKGyuOUd6g
+rONcv0W6W8L9oL6F/5Hf5eh9hV/UIeKhcqfZJ31pkXUvF7rmvf3V649e/Cn
8OGKt5Q/o/ibvlO8W9xP/yg/UdFU0am4/pZUtFPeLO8vFEsoXz7v5+98Fp7p
L+pe8U5x/x6ke2mrH55cXe81/P2L8p6O57uqv5vfOI61U7RR3iSvN1a0Vd40
12ux6mtt8v0NuUflK2S9NNLv9ave3/n6uwY9WswHq+r6TcL9FROzn+9UnKz8
pKwHapG9pwZG67t+1/V7lO9RXR+bKWYLX6X4T9Ynv0VN7al8UAPXENe3EF5N
eF3hY+kJ4f7C6wgfTc8KDxBev/r3+fyTiruU36mYrPwpxX3K71XsrvwJxe3K
b1NsovxZfXas4ijuUXhgA9c097+38OAG7oFr8vuGCu8gfJ3wB9W9Ti/enP2y
eXIB73+nmhsuUH6tooM+P1sxTvn6ivequYDev0HRR9fmhbkITno/ueEi5Tcq
Pqzu/UuV36Lon3yxo/JJip7Z/3AVnIV4DNH9Tqz+/f2EhwvvWP19qyefwa07
K3ZMPtpYMVP4Xf3dUjG3+Hn5/NNh7nhAMUX5MH3fpOr7P0x4lPDu1Xt+qPBI
4V2r92Oi8ENh7pub/be/4inlbyQ/7Ffdiwuz/9E6eo2eQy/gbrgDDpmu71pD
379X9f3MSH3bR7FA+PBwDVJ77D/6QS+hFWgG+rGv4jHlryp20fsfV1xWvMbo
692K05WfVswNcAT8cXJ1Pd4T5raZyQdoK9r3XvYzWgw3vJvr8XxYe/jNqcnH
O1XXD/f7YpjrWJODqc9w7z+sOED5M6xh8fPBRwconqX2irUWzYUPT6vuj/lh
7p6dnx+h9di5un7or/sUs5SfrdhK+f1hLj8n92t1vX/D6ufvxHeFtQRN+Qt/
EeaXM2pqdVgbb6vWYjS5vfIhcA7rJ9xOeLDw8sIh3FZ4YLH+4ElWqf6O5YQr
mi68unBv4YbCfat7ZI7+dlCMgEsUS+v6WfC/oq9wc+G/0cjq660QAX2+NRxW
fO88QyvhnsXXeM+KSmfptZbK/0HjlffTaw9We5dpxf5ngfI1FYcV+5/e2b/0
Nj2+pvKl9Z0jqXPhtYVbCI9i34THCC8lPIK6L9b/JYQHVPc0984zdFJ+JnWq
+K9iRvHnH63mQriL73+8miuPUX4gNVPtDfFS+yrG6rta6vtHV19/qNprHV7s
7x5JLpxefD88O2uAFp5dvXfsIWs1u3rv2MMewufBc4qOipHF63+h8s5oSPF6
4x3xkNsqv7Paaw5Nvruj+t64R7zqA9VrMyb57d7qtVs7+ep+4fWU36E4Qfj4
Yu3qm/V5Y/VasqZ4qVuEVwr7G2oLD/evNxbeUvntur5i2A/xfjzY4LD/2135
bophYb+IFu6hGBH2Q+z93orR8IG+Z3j1eq8hfGN4LacU1wI1sZPy++BxRXf2
tLg/5invQo1RC8W+v5NidHH9ddZnrxBeufoZ6Q16BG99Ljqh6Frt5eiXS5R3
q/Zy9NvFPCM1Udxva+mzt4RraapiHbRRcbDyg4q9PzPAROV3V/Pty2FvAufQ
i71Tz66vngXwiOj5XTxXfh9rxxrC1X/AMcWc/UFy303Ffhmt+iGsnWjWUfl7
cPv8Yi76RvjUYk5C+78WPrHYA+AdvgtrNx4C7f4+7F/R8COSX9ECPAFa9Rsc
X6xZaNWv1FSxZnUTfjvML/AM2v9jWEvxAHDpL2HuhlPxDt+G/TAeYkXht4S7
sffVfg4+x3vgQfYK+xW8Dve4b9ivoLXXF9f7reFehTOOCc9XcD8aQH/cFO59
OIT9uiFce8xsXYXfDHtDfOi01B+0GI/URdffCHvBRrl/14e5gJkObf8pfC9o
PN7h57DW4yGYdx4Jax8auFvYX11evAbMep+F+RLe7CP8sfB44V5wsvCnYX+J
z+wt/JHwBsI9hFcR/kR4M+E+1VpyrvDQkprSwB4Hr/FpdX2gWXiLV5Ovzgn3
FpqDtszNfkdjegl/GO4/+rCn8Afh/qBPugu/E+YzeG1M9vOkYk7Cm34V5lt4
l/kOf4NW4hmYzb8I8y88zLyGvsJVcFYPXX8v3O/0/crC74f7lz7eNexH0OZZ
yR83h3sVTWFW/jzM3/A48yt6jxfGk6+k6++G+RcebqH89DCXrFrMt7eFe/1f
TQj7C7zBrcX7gUfHm9+Q+9c/n//m6lmamqKWvs39XD/78YncPzwm3vJW4VbC
G4T18qnqWfnRsH/GRzN7Pxj2z/hoZp/nwn4N38asvSDsp/HVzNIPh/0zPprZ
+LGwd8MnU9+NhVdmP/L97BF78xrcKrx49ucp1WcncA5c8xPaJdxQuLvwqdWz
9oTUmxfz/uhpevnr6lmXmRd9fj6fhz1hL17O+2OGP0v4jXx+eojeWZjPx5nC
KcKvVJ/1wFlw1Q+53i+E/e+U/L178/vGZz0zA+D9r0v+6pj9dFl1PXTN/ruy
Wi8vSX7vl3p8TdjbcAaEn7sirMcDsx/wgHi/y6vnBfof7r6oWN+vDWshZ0To
65XJ/5xBsffUwLjqNUE/Lgr7ATwd/YAGo71XpX5fFtbLAdmfaDjafU3uz8Lw
vN8g9/P18Cxdk3+XFR4gfE71Wcxr4dmZuR5+bCrcW/nMXO+XwvPG1KyHV8L+
/cDsz+7JR1dXn6cwDzFLoWE82125f+OyXh4Iz8PMxfDhuOzPJ1Ov9kw+/rh6
tv0y7OfwddTuSWG/RQ13Ces/noCeZi/YE7hpVPHessed00PgH/CueC/eT62z
RqwNa4Z/xhvj1eC4pXT91LBXXqXYb+D3+W48CL3AmrPWnF+0TD7pUuwRWRvW
qGt6DPaSPYXbOGNqH55/hxdrKn4T3UK/eGb8C14fb8Lnx4fn842qexavc2b2
I56HvWMP0TbO9/BPbar3m9/Df+L18VKsB/6U2QDu45noDXoEbef58UvoBHqB
JuDP0Bn0hjM1vO+s5BP2pHmuV8dij85+wTloKecpcCccipbRM8yOx4XPupgh
mdVOCK8lMxv+HR6GjznvgEvhVLQRDcX/4wPwA2gO/hK/uVo1J/cLn8/0rO5x
uBrORmvpKeYBvCle9Mji+QWdR+/REOYBfAP+Ac1qRi2H17ZDcS/RU3gZ9oB+
itz/k1JfmL+aVb9Gr9KzaOnY3E/maX57evF52bHCSxef0aEVaAZaT48zb8Ej
8AnnxZxHwUvwE+vRJPuDtWYGhfvgQLSc/cLPMXMza39T7X+ZNQcV3087ejP7
v0+xv+OMB3/4WbV/5AwIf/hJdf2zX9Qez8/8c3b4+/hezgeOD8+PnCHid/HM
eOUfa/l3vpwZrkfqknn9xPD81CL5kfM0nhWNbJv3N6y4BjmPwXfiP9FA/Acz
PP7gheQPziTwY89V+1HOtPCzH1WfR+Gr8ddzcj/pJ2YFembd8Dx1SLEn4/wJ
n4ffm1d8/oTPxe+i2a2zH5gtWAP8CGf4+POnq/05ZxCcPbxU7Yc4U8EfPVPd
v9QXa88eMM+cFe5/eID5Fp+D3zm6eB4+LcxX8Bb+mzONBcJfVdci/QUXUX/M
9ieH/x/AjM9ZEGcsnK18z36E64/epYfxt5xxMW98Ue1/OeNiXvm8evZkXsLP
MIMyP3DmxXnVd9Xz8hlhvoV3Od/DN+OfOfPCG3BexLPgEbYMn7/Q68cp/g8d
072F
            "]], Polygon3DBox[CompressedData["
1:eJwtlGtMj2EYh99MG0NKmfMshL+IIvKBsWVCKYUxE5qSdHT4YMNsZiOKKMTY
mjmfT/31pyyzrGhJ5Hwm5zM5fOH6bfeH68P12973ee7nvp8nMCkrPrOF4zhR
4A3pyFdo8nKcVCgjS8U/w0s8BUrJRuIHoRQfDDP1PX4P8nFfCCKLwA/AOTwE
ZpBl4N/gNb4QPGTh+D44gw+EaWQt8buQh7eHPmSt8PuwGe8A/S3LhU24N3Qh
y8F/wjs8HSrsf+tgI/4P7wgr8T+qmWwJ1JBNxz9APZ4AhWRL8WbleCZUkiXg
76EOnwIFZGn4F3iFLwA32Sz8IzSoLigm06F/hzd4Glwgm4N/gkadE+wmi1MN
UIvHQj7ZCvy31sEXQzWZF34HNuDtIJBsOf5L/8SzoYqsjeqHArw1dCdbjf/V
fvBlUEsWi5fBNTwSVpGNwo+AGx8Cs8l64U80C/gAnQNZD/yR+on3gxiy3vhT
OIQHQzxZT/wx7FcfYTJZtM4EavBoyCULwB/CdvUWhlltdTpXm0m31dGg2cIX
Wc9d+As4ZnOq+QvCn8Fhm7WpZH3x56oPH2Tzl4Rf0bnicdbfZLxKc64abDZS
8KuaS5uXIutRve6N3SOP9fcy3Fat1kvN2kW4gU+AtWSJeCXc0tlBHtkafQc/
8AybP83VJbiJT7KzCsX3wkncZf0I0d2FE3io9U39fQvXbS9aYwx+XH3Hw2Au
WSR+SnvEw2E+2Tj8NJTjwyHZ1ijR99Zz9TJK9157xCN0DmRjtQ/w4ENhHtlo
/Cict/0lko3Hz0IFPkJ3yeZgC2yz90DvS2e8CIrtPXCRdcILYQfuZ29ENzns
wgPUd3tzmrSO1aHawnR3VZ/mzPY3UW8VVNs5r7d79ED7sf8Fk3XVjMJO3N8y
zd8e1af9qsdk/rp/2jfuY++ar94v2Iq3tfubrX6rTzbP5WT/AWXVtnQ=
            "]]},
          Annotation[#, "Charting`Private`Tag$2529#1"]& ]],
        Lighting->"Neutral"]}, {}, {}, {}, {}}, {{}, {}, {}, 
      {RGBColor[0, 0, 1], Thickness[0.0003], 
       Line3DBox[{250, 385, 251, 394, 268, 403, 766, 277, 412, 286, 805, 421, 
        295, 430, 774, 304, 439, 779, 313, 448, 322, 815, 457, 331, 466, 789, 
        340, 475, 349, 823, 484, 358, 493, 795, 367, 502, 376},
        VertexColors->None], 
       Line3DBox[{252, 386, 253, 799, 395, 269, 404, 278, 413, 287, 806, 422, 
        296, 812, 431, 305, 440, 780, 314, 449, 323, 816, 458, 332, 821, 467, 
        341, 476, 350, 824, 485, 359, 831, 494, 368, 503, 377},
        VertexColors->None], 
       Line3DBox[{254, 387, 255, 396, 763, 270, 405, 767, 279, 414, 288, 423, 
        297, 432, 775, 306, 441, 781, 315, 450, 324, 459, 787, 333, 468, 790, 
        342, 477, 351, 825, 486, 360, 495, 796, 369, 504, 378},
        VertexColors->None], 
       Line3DBox[{256, 388, 257, 800, 397, 271, 406, 768, 280, 415, 289, 807, 
        424, 298, 433, 307, 442, 782, 316, 451, 325, 817, 460, 334, 469, 791, 
        343, 478, 352, 826, 487, 361, 832, 496, 370, 505, 379},
        VertexColors->None], 
       Line3DBox[{258, 389, 259, 801, 398, 272, 804, 407, 281, 416, 290, 808, 
        425, 299, 813, 434, 308, 443, 317, 452, 326, 818, 461, 335, 822, 470, 
        344, 479, 353, 827, 488, 362, 833, 497, 371, 506, 380},
        VertexColors->None], 
       Line3DBox[{260, 390, 261, 399, 764, 273, 408, 769, 282, 417, 291, 809, 
        426, 300, 435, 776, 309, 444, 783, 318, 453, 327, 462, 336, 471, 792, 
        345, 480, 354, 828, 489, 363, 498, 797, 372, 507, 381},
        VertexColors->None], 
       Line3DBox[{262, 391, 263, 802, 400, 274, 409, 770, 283, 418, 292, 810, 
        427, 301, 814, 436, 310, 445, 784, 319, 454, 328, 819, 463, 337, 472, 
        346, 481, 355, 829, 490, 364, 834, 499, 373, 508, 382},
        VertexColors->None], 
       Line3DBox[{264, 392, 265, 401, 765, 275, 410, 771, 284, 419, 293, 428, 
        773, 302, 437, 777, 311, 446, 785, 320, 455, 329, 464, 788, 338, 473, 
        793, 347, 482, 356, 491, 365, 500, 798, 374, 509, 383},
        VertexColors->None], 
       Line3DBox[{266, 393, 267, 803, 402, 276, 411, 772, 285, 420, 294, 811, 
        429, 303, 438, 778, 312, 447, 786, 321, 456, 330, 820, 465, 339, 474, 
        794, 348, 483, 357, 830, 492, 366, 501, 375, 510, 384},
        VertexColors->None]}, 
      {RGBColor[1, 0, 0], Thickness[0.0003], 
       Line3DBox[{512, 646, 511, 394, 513, 727, 799, 514, 647, 515, 763, 648, 
        516, 728, 800, 517, 729, 801, 518, 649, 519, 764, 650, 520, 730, 802, 
        521, 651, 522, 765, 652, 523, 731, 803, 524, 653, 525},
        VertexColors->None], 
       Line3DBox[{527, 654, 526, 766, 655, 528, 404, 529, 656, 530, 767, 657, 
        531, 768, 658, 532, 732, 804, 533, 659, 534, 769, 660, 535, 770, 661, 
        536, 662, 537, 771, 663, 538, 772, 664, 539, 665, 540},
        VertexColors->None], 
       Line3DBox[{542, 666, 541, 733, 805, 543, 734, 806, 544, 667, 545, 423, 
        546, 735, 807, 547, 736, 808, 548, 668, 549, 737, 809, 550, 738, 810, 
        551, 669, 552, 773, 670, 553, 739, 811, 554, 671, 555},
        VertexColors->None], 
       Line3DBox[{557, 672, 556, 774, 673, 558, 740, 812, 559, 674, 560, 775, 
        675, 561, 433, 562, 741, 813, 563, 676, 564, 776, 677, 565, 742, 814, 
        566, 678, 567, 777, 679, 568, 778, 680, 569, 681, 570},
        VertexColors->None], 
       Line3DBox[{572, 682, 571, 779, 683, 573, 780, 684, 574, 685, 575, 781, 
        686, 576, 782, 687, 577, 443, 578, 688, 579, 783, 689, 580, 784, 690, 
        581, 691, 582, 785, 692, 583, 786, 693, 584, 694, 585},
        VertexColors->None], 
       Line3DBox[{587, 695, 586, 743, 815, 588, 744, 816, 589, 696, 590, 787, 
        697, 591, 745, 817, 592, 746, 818, 593, 698, 594, 462, 595, 747, 819, 
        596, 699, 597, 788, 700, 598, 748, 820, 599, 701, 600},
        VertexColors->None], 
       Line3DBox[{602, 702, 601, 789, 703, 603, 749, 821, 604, 704, 605, 790, 
        705, 606, 791, 706, 607, 750, 822, 608, 707, 609, 792, 708, 610, 472, 
        611, 709, 612, 793, 710, 613, 794, 711, 614, 712, 615},
        VertexColors->None], 
       Line3DBox[{617, 713, 616, 751, 823, 618, 752, 824, 619, 714, 620, 753, 
        825, 621, 754, 826, 622, 755, 827, 623, 715, 624, 756, 828, 625, 757, 
        829, 626, 716, 627, 491, 628, 758, 830, 629, 717, 630},
        VertexColors->None], 
       Line3DBox[{632, 718, 631, 795, 719, 633, 759, 831, 634, 720, 635, 796, 
        721, 636, 760, 832, 637, 761, 833, 638, 722, 639, 797, 723, 640, 762, 
        834, 641, 724, 642, 798, 725, 643, 501, 644, 726, 645},
        VertexColors->None]}}},
    VertexColors->CompressedData["
1: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
qva5HeskWPFZJWnvPHLOoeZxWttF+FG5U6zYIUawvoFNXp0Y99Ly9i+YI0Rw
xizDrYfFeFwQ6H16lRiJ55SDA7r5mHeV+2Ez4b/tbxpfsVMIboRrKBS84qHT
0PtSlB4NJxWrkkqBCHXpJTJFSRRSLk+rv2YrgsyUWcVHFUQQOH/0mXyWi/HL
jKRd/YRIXhTV7aYvRK+JbYQ4nAOP4xbvd3gK4G6+5siiVQL0qOt8XPGIjdro
ZD/pbXxMj4+73+TCh4k4qdGojfBjemWX9goe9ruxzRdc4aG6Zrl1F8GHAV2Z
Zz/mUDgre7T9WxMF/ym+23/MYWHlx5mz5xpy0TlkY4uhOwWVxt7fJ51ZeKmW
Ht6xlINnrtlXbo2l8LF0j7RfPguqyu+2MXwqXa73lOHT2kt9Fxk+lVE7pbnT
n6nnMTqfXCSIWSFuGS1LI3VYosienK/7rFdsWRUJNN5neyf0CDFvFo++2CDG
BUX5/W8yxLC11mzfzyLvt/zH23W7xDDIKSm1NxZDJ71p7YJyPmwNWjZOfkej
avGIq1LxNK6M85wqzOUBBkcbZxjRkGdX2xW0itCcGzmgdZv069qpfQ8DRJhT
Un9PoieCh3vw0wWZXBwKfT/MMkUIPY14RW1XIfya3sewSjhos6tarlEswLPZ
dYVJsQLUbvroqfGTjRB+dN2caj4+dHnUgOCK/wjOsVawkX3n4ci3DTyUIKrc
7jcPC5PXO3c8ZkFdcniS9AcKc697+nSt4kFgLFBxI+d52azR8hiHi2fLR5yf
n0/hwoeh8odNWfg+qiK7sp+D1XNjO8ysKIRHLhBFEJxxn63zyXIOB5lOHhp2
4yicOzR3c1oDua9+nVcKmyXo3BXcYgrCh5Obbg+EihC2UG5Hq7IE15d/VE7v
EcPO6MzTndFCBEa50eMeiZHW1RZHnxFD5s8FzwfnBdj7pWCvqY0Y6bdlxs+Y
IsajisSJAxcJL1W8q2ZV0DC6u8h7ShSNttQsA+VkHiLmRE9+ZUKj7Naqb/d+
iEAVbuo5l02eS0p9WmWMCA7bA+OcVosg8Zsha090VOPzg6N1PwiRNyp1juiC
ELzDm+Pf93Hgr2+dRykKIa9i82egWYDk0+F/BhlxYGx6ZPbWhQKc3rzk260p
AtyboaV5m9RZ15rUtPekvged02at2cHHg6qXa9YS3abdasRdeIwH/3fse59K
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
bQ==
     "],
    VertexNormals->CompressedData["
1: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
tkeyA6qgaVOL5c33DWiF59DEFBOHvwERpBKM
     "]], 
   {RGBColor[1., 1, 0.5], Arrowheads[0.02], 
    Arrow3DBox[TubeBox[{{{0.8787692307692307, 0.060307692307692284`, 
     1.6710769230769231`}, {0.6479999999999999, 0.368, 0.748}}}, Scaled[
     0.002]], 0.], 
    {RGBColor[0, 1, 1], Specularity[
      GrayLevel[1], 50], 
     SphereBox[{0.8787692307692307, 0.060307692307692284`, 
      1.6710769230769231`}, Scaled[0.004]], 
     {RGBColor[
       NCache[
        Rational[2, 3], 0.6666666666666666], 0, 0], 
      SphereBox[{0.6479999999999999, 0.368, 0.748}, Scaled[0.004]]}}}},
  PlotStyle -> Specularity[
    GrayLevel[1], 500],
  Axes->All,
  AxesLabel->None,
  AxesStyle->Directive[Bold, 12],
  Boxed->False,
  ImageSize->{800., 800.},
  Lighting->{{"Point", 
     RGBColor[1, 0.5, 0], {1, 1, 1}}, {"Point", 
     GrayLevel[1], {-4, -4, 4}}},
  PlotRange->All,
  ViewAngle->0.42890074313446275`,
  ViewCenter->{{0.5, 0.5, 0.5}, {0.38483963302085666`, 0.7185475499269199}},
  ViewPoint->{0.3037451941836016, -3.1966928424754397`, 1.0671896400718393`},
  ViewVertical->{0.08277170530052574, -0.3393922963446973, 
   0.9369961120429028}]], "Print",
 CellChangeTimes->{3.760484511412568*^9, 3.7604846794186525`*^9},
 CellLabel->
  "During evaluation of \
In[15]:=",ExpressionUUID->"455cdd05-867f-4c4f-b251-36a0e20763ba"]
}, Open  ]]
}, Open  ]],

Cell["", "PageBreak",
 PageBreakBelow->True,ExpressionUUID->"5019056e-a245-40b6-b7fc-08130c911bda"]
}, Open  ]],

Cell[CellGroupData[{

Cell[TextData[{
 "(ray ",
 StyleBox["\[Intersection]", "OperatorCharacter"],
 " quad) in world coordinates\n",
 StyleBox["\n",
  FontSize->14],
 StyleBox["We find coefficients for the quadratic equation for ",
  FontSize->16,
  FontColor->GrayLevel[0]],
 StyleBox["u",
  FontSize->16,
  FontWeight->"Bold",
  FontColor->GrayLevel[0]],
 StyleBox[" (section ",
  FontSize->16,
  FontColor->GrayLevel[0]],
 StyleBox["8.4 Code",
  FontSize->16,
  FontWeight->"Bold",
  FontColor->GrayLevel[0]],
 StyleBox[") as follows:\n\n1.  find a volume of the corresponding \
parallelepiped  (section ",
  FontSize->16,
  FontColor->GrayLevel[0]],
 StyleBox["8.2",
  FontSize->16,
  FontWeight->"Bold",
  FontColor->GrayLevel[0]],
 StyleBox[" ",
  FontSize->16,
  FontColor->GrayLevel[0]],
 StyleBox["GARP Details",
  FontSize->16,
  FontWeight->"Bold",
  FontSlant->"Italic",
  FontColor->GrayLevel[0]],
 StyleBox[") and set it to 0\n2.  It yields coefficients given by ",
  FontSize->16,
  FontColor->GrayLevel[0]],
 StyleBox["polu",
  FontSize->16,
  FontWeight->"Bold",
  FontColor->GrayLevel[0]],
 StyleBox["\n3.  We guestimate the corresponding vector expressions for a, c, \
and a+b+c and\n4.  Verify that such expressions are equal to ",
  FontSize->16,
  FontColor->GrayLevel[0]],
 StyleBox["polu",
  FontSize->16,
  FontWeight->"Bold",
  FontColor->GrayLevel[0]],
 StyleBox[" terms.",
  FontSize->16,
  FontColor->GrayLevel[0]]
}], "Section",
 CellFrame->{{0, 0}, {2, 0}},
 CellChangeTimes->{{3.7453538106390963`*^9, 3.7453538295470963`*^9}, {
   3.7462033652293243`*^9, 3.7462033686926703`*^9}, 3.7462140185307293`*^9, 
   3.7604813330228977`*^9, {3.7604814781903906`*^9, 3.7604815046032887`*^9}, {
   3.7604815763444405`*^9, 3.760481795429043*^9}, {3.760481825759118*^9, 
   3.7604818856953278`*^9}, {3.7604819900266924`*^9, 3.760481992774466*^9}, {
   3.7604824990034037`*^9, 3.760482517663619*^9}, 
   3.7604837265854297`*^9},ExpressionUUID->"7490b891-9591-414f-a8a8-\
dc4431acf30d"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"Clear", "[", 
   RowBox[{"p", ",", "o", ",", "d", ",", "u", ",", "v", ",", "t"}], "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"v4", " ", "=", 
    RowBox[{"Table", "[", 
     RowBox[{
      RowBox[{"Subscript", "[", 
       RowBox[{"p", ",", 
        RowBox[{
         RowBox[{"10", "*", "i"}], "+", "j"}]}], "]"}], ",", 
      RowBox[{"{", 
       RowBox[{"i", ",", "4"}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"j", ",", "3"}], "}"}]}], "]"}]}], ";"}], " ", 
  RowBox[{"(*", "  ", 
   RowBox[{"4", " ", "corner", " ", "points"}], " ", 
   "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"ro", " ", "=", " ", 
    RowBox[{"Table", "[", 
     RowBox[{
      RowBox[{"Subscript", "[", 
       RowBox[{"o", ",", "i"}], "]"}], ",", 
      RowBox[{"{", 
       RowBox[{"i", ",", "3"}], "}"}]}], "]"}]}], ";"}], 
  RowBox[{"(*", " ", 
   RowBox[{"ray", " ", "origin"}], "    ", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"rd", " ", "=", " ", 
    RowBox[{"Table", "[", 
     RowBox[{
      RowBox[{"Subscript", "[", 
       RowBox[{"d", ",", "i"}], "]"}], ",", 
      RowBox[{"{", 
       RowBox[{"i", ",", "3"}], "}"}]}], "]"}]}], ";"}], 
  RowBox[{"(*", " ", 
   RowBox[{"ray", " ", "direction"}], " ", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"p12", " ", "=", " ", 
   RowBox[{"lerp", "[", 
    RowBox[{
     RowBox[{"v4", "[", 
      RowBox[{"[", "1", "]"}], "]"}], ",", " ", 
     RowBox[{"v4", "[", 
      RowBox[{"[", "2", "]"}], "]"}], ",", " ", "u"}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"p43", " ", "=", " ", 
    RowBox[{"lerp", "[", 
     RowBox[{
      RowBox[{"v4", "[", 
       RowBox[{"[", "4", "]"}], "]"}], ",", " ", 
      RowBox[{"v4", "[", 
       RowBox[{"[", "3", "]"}], "]"}], ",", " ", "u"}], "]"}]}], ";"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", " ", "1.", " ", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{
    RowBox[{"parallelepipedVolume", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"l0_", ",", "ld_"}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"m0_", ",", "md_"}], "}"}]}], "]"}], " ", ":=", " ", 
    RowBox[{
     RowBox[{"(", 
      RowBox[{"m0", "-", "l0"}], ")"}], ".", 
     RowBox[{"ld", "\[Cross]", "md"}]}]}], ";"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", "2.", " ", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"polu", " ", "=", " ", 
    RowBox[{"FullSimplify", "[", 
     RowBox[{"CoefficientList", "[", 
      RowBox[{
       RowBox[{"parallelepipedVolume", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{"ro", ",", "rd"}], "}"}], ",", " ", 
         RowBox[{"{", 
          RowBox[{"p12", ",", " ", 
           RowBox[{"p43", " ", "-", " ", "p12"}]}], "}"}]}], "]"}], ",", " ", 
       "u"}], "]"}], "]"}]}], ";"}], " "}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"polu", "//", "TraditionalForm"}], "//", "Print"}], 
  "\[IndentingNewLine]", "\[IndentingNewLine]", 
  RowBox[{"(*", " ", "3.", " ", "*)"}], "\[IndentingNewLine]", 
  "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{"a", " ", "term"}], " ", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"terma", " ", "=", " ", 
    RowBox[{
     RowBox[{"Cross", "[", 
      RowBox[{
       RowBox[{
        RowBox[{"v4", "[", 
         RowBox[{"[", "1", "]"}], "]"}], " ", "-", " ", 
        RowBox[{"v4", "[", 
         RowBox[{"[", "4", "]"}], "]"}]}], ",", " ", "rd"}], "]"}], ".", 
     RowBox[{"(", 
      RowBox[{
       RowBox[{"v4", "[", 
        RowBox[{"[", "1", "]"}], "]"}], "-", "ro"}], ")"}]}]}], ";"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{"c", " ", "term", " ", 
    RowBox[{"(", 
     RowBox[{
     "it", " ", "does", " ", "not", " ", "depend", " ", "on", " ", "ro"}], 
     ")"}]}], " ", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"termc", " ", "=", 
    RowBox[{
     RowBox[{"Cross", "[", 
      RowBox[{
       RowBox[{
        RowBox[{"v4", "[", 
         RowBox[{"[", "4", "]"}], "]"}], "-", 
        RowBox[{"v4", "[", 
         RowBox[{"[", "3", "]"}], "]"}]}], ",", " ", 
       RowBox[{
        RowBox[{"v4", "[", 
         RowBox[{"[", "1", "]"}], "]"}], " ", "-", " ", 
        RowBox[{"v4", "[", 
         RowBox[{"[", "2", "]"}], "]"}]}]}], "]"}], ".", "rd"}]}], ";"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{
    RowBox[{"sum", " ", "of", " ", "a"}], ",", "b", ",", 
    RowBox[{"c", " ", "is"}]}], " ", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"terms", " ", "=", 
    RowBox[{
     RowBox[{"Cross", "[", 
      RowBox[{
       RowBox[{
        RowBox[{"v4", "[", 
         RowBox[{"[", "2", "]"}], "]"}], " ", "-", " ", "ro"}], ",", " ", 
       RowBox[{"ro", " ", "-", " ", 
        RowBox[{"v4", "[", 
         RowBox[{"[", "3", "]"}], "]"}]}]}], "]"}], ".", "rd"}]}], ";"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", " ", "or", " ", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"terms", " ", "=", 
    RowBox[{
     RowBox[{"Cross", "[", 
      RowBox[{
       RowBox[{
        RowBox[{"v4", "[", 
         RowBox[{"[", "2", "]"}], "]"}], " ", "-", " ", "ro"}], ",", " ", 
       RowBox[{
        RowBox[{"v4", "[", 
         RowBox[{"[", "2", "]"}], "]"}], " ", "-", " ", 
        RowBox[{"v4", "[", 
         RowBox[{"[", "3", "]"}], "]"}]}]}], "]"}], ".", "rd"}]}], ";"}], 
  "\[IndentingNewLine]", "\[IndentingNewLine]", 
  RowBox[{"(*", " ", "4.", " ", "*)"}], 
  "\[IndentingNewLine]"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"{", 
   RowBox[{
    RowBox[{"Expand", "[", 
     RowBox[{
      RowBox[{"polu", "[", 
       RowBox[{"[", "1", "]"}], "]"}], " ", "\[Equal]", " ", "terma"}], "]"}],
     ",", 
    RowBox[{"Expand", "[", 
     RowBox[{
      RowBox[{"polu", "[", 
       RowBox[{"[", "3", "]"}], "]"}], " ", "\[Equal]", " ", "termc"}], "]"}],
     ",", 
    RowBox[{"Expand", "[", 
     RowBox[{
      RowBox[{"Total", "[", "polu", "]"}], " ", "\[Equal]", " ", "terms"}], 
     "]"}]}], "}"}], "//", "Print"}]}], "Input",
 CellChangeTimes->{{3.760311809135254*^9, 3.760311810767883*^9}, {
   3.7603646467853208`*^9, 3.7603646630402317`*^9}, {3.760364695088358*^9, 
   3.7603647188235073`*^9}, {3.760480986673746*^9, 3.7604810575736513`*^9}, {
   3.7604811430668397`*^9, 3.7604812491906796`*^9}, 3.7604812857514563`*^9, {
   3.7604815217413273`*^9, 3.760481533428602*^9}, {3.760481924616598*^9, 
   3.760481965019773*^9}, {3.760482732587182*^9, 3.7604827720272245`*^9}, {
   3.7604828108943715`*^9, 3.7604828444522934`*^9}, {3.7604836520866413`*^9, 
   3.760483653939074*^9}, {3.76048368719741*^9, 3.7604837099877415`*^9}, 
   3.7604846683188963`*^9},
 CellLabel->"In[34]:=",ExpressionUUID->"ee4a1d0f-90f8-4362-92a2-b535a357100f"],

Cell[CellGroupData[{

Cell[BoxData[
 TagBox[
  FormBox[
   RowBox[{"{", 
    RowBox[{
     RowBox[{
      RowBox[{
       SubscriptBox["d", "3"], " ", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          SubscriptBox["o", "2"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "11"], "-", 
            SubscriptBox["p", "41"]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["p", "12"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "41"], "-", 
            SubscriptBox["o", "1"]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["p", "42"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["o", "1"], "-", 
            SubscriptBox["p", "11"]}], ")"}]}]}], ")"}]}], "+", 
      RowBox[{
       SubscriptBox["d", "2"], " ", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          SubscriptBox["p", "13"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["o", "1"], "-", 
            SubscriptBox["p", "41"]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["o", "3"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "41"], "-", 
            SubscriptBox["p", "11"]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["p", "43"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "11"], "-", 
            SubscriptBox["o", "1"]}], ")"}]}]}], ")"}]}], "+", 
      RowBox[{
       SubscriptBox["d", "1"], " ", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          SubscriptBox["o", "3"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "12"], "-", 
            SubscriptBox["p", "42"]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["p", "13"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "42"], "-", 
            SubscriptBox["o", "2"]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["p", "43"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["o", "2"], "-", 
            SubscriptBox["p", "12"]}], ")"}]}]}], ")"}]}]}], ",", 
     RowBox[{
      RowBox[{
       SubscriptBox["d", "3"], " ", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          SubscriptBox["o", "2"], " ", 
          RowBox[{"(", 
           RowBox[{
            RowBox[{"-", 
             SubscriptBox["p", "11"]}], "+", 
            SubscriptBox["p", "21"], "-", 
            SubscriptBox["p", "31"], "+", 
            SubscriptBox["p", "41"]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["o", "1"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "12"], "-", 
            SubscriptBox["p", "22"], "+", 
            SubscriptBox["p", "32"], "-", 
            SubscriptBox["p", "42"]}], ")"}]}], "-", 
         RowBox[{
          SubscriptBox["p", "11"], " ", 
          SubscriptBox["p", "32"]}], "+", 
         RowBox[{
          SubscriptBox["p", "12"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "31"], "-", 
            RowBox[{"2", " ", 
             SubscriptBox["p", "41"]}]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["p", "22"], " ", 
          SubscriptBox["p", "41"]}], "+", 
         RowBox[{
          RowBox[{"(", 
           RowBox[{
            RowBox[{"2", " ", 
             SubscriptBox["p", "11"]}], "-", 
            SubscriptBox["p", "21"]}], ")"}], " ", 
          SubscriptBox["p", "42"]}]}], ")"}]}], "+", 
      RowBox[{
       SubscriptBox["d", "1"], " ", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          SubscriptBox["o", "3"], " ", 
          RowBox[{"(", 
           RowBox[{
            RowBox[{"-", 
             SubscriptBox["p", "12"]}], "+", 
            SubscriptBox["p", "22"], "-", 
            SubscriptBox["p", "32"], "+", 
            SubscriptBox["p", "42"]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["o", "2"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "13"], "-", 
            SubscriptBox["p", "23"], "+", 
            SubscriptBox["p", "33"], "-", 
            SubscriptBox["p", "43"]}], ")"}]}], "-", 
         RowBox[{
          SubscriptBox["p", "12"], " ", 
          SubscriptBox["p", "33"]}], "+", 
         RowBox[{
          SubscriptBox["p", "13"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "32"], "-", 
            RowBox[{"2", " ", 
             SubscriptBox["p", "42"]}]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["p", "23"], " ", 
          SubscriptBox["p", "42"]}], "+", 
         RowBox[{
          RowBox[{"(", 
           RowBox[{
            RowBox[{"2", " ", 
             SubscriptBox["p", "12"]}], "-", 
            SubscriptBox["p", "22"]}], ")"}], " ", 
          SubscriptBox["p", "43"]}]}], ")"}]}], "+", 
      RowBox[{
       SubscriptBox["d", "2"], " ", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          SubscriptBox["o", "3"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "11"], "-", 
            SubscriptBox["p", "21"], "+", 
            SubscriptBox["p", "31"], "-", 
            SubscriptBox["p", "41"]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["o", "1"], " ", 
          RowBox[{"(", 
           RowBox[{
            RowBox[{"-", 
             SubscriptBox["p", "13"]}], "+", 
            SubscriptBox["p", "23"], "-", 
            SubscriptBox["p", "33"], "+", 
            SubscriptBox["p", "43"]}], ")"}]}], "-", 
         RowBox[{
          SubscriptBox["p", "13"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "31"], "-", 
            RowBox[{"2", " ", 
             SubscriptBox["p", "41"]}]}], ")"}]}], "-", 
         RowBox[{
          SubscriptBox["p", "23"], " ", 
          SubscriptBox["p", "41"]}], "+", 
         RowBox[{
          SubscriptBox["p", "11"], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "33"], "-", 
            RowBox[{"2", " ", 
             SubscriptBox["p", "43"]}]}], ")"}]}], "+", 
         RowBox[{
          SubscriptBox["p", "21"], " ", 
          SubscriptBox["p", "43"]}]}], ")"}]}]}], ",", 
     RowBox[{
      RowBox[{
       SubscriptBox["d", "3"], " ", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "11"], "-", 
            SubscriptBox["p", "21"]}], ")"}], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "32"], "-", 
            SubscriptBox["p", "42"]}], ")"}]}], "-", 
         RowBox[{
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "12"], "-", 
            SubscriptBox["p", "22"]}], ")"}], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "31"], "-", 
            SubscriptBox["p", "41"]}], ")"}]}]}], ")"}]}], "+", 
      RowBox[{
       SubscriptBox["d", "2"], " ", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "13"], "-", 
            SubscriptBox["p", "23"]}], ")"}], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "31"], "-", 
            SubscriptBox["p", "41"]}], ")"}]}], "-", 
         RowBox[{
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "11"], "-", 
            SubscriptBox["p", "21"]}], ")"}], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "33"], "-", 
            SubscriptBox["p", "43"]}], ")"}]}]}], ")"}]}], "+", 
      RowBox[{
       SubscriptBox["d", "1"], " ", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "12"], "-", 
            SubscriptBox["p", "22"]}], ")"}], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "33"], "-", 
            SubscriptBox["p", "43"]}], ")"}]}], "-", 
         RowBox[{
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "13"], "-", 
            SubscriptBox["p", "23"]}], ")"}], " ", 
          RowBox[{"(", 
           RowBox[{
            SubscriptBox["p", "32"], "-", 
            SubscriptBox["p", "42"]}], ")"}]}]}], ")"}]}]}]}], "}"}],
   TraditionalForm],
  TraditionalForm,
  Editable->True]], "Print",
 CellChangeTimes->{
  3.7603117167834387`*^9, 3.760311812935465*^9, {3.7603646482357903`*^9, 
   3.7603646645876083`*^9}, {3.7603647000666604`*^9, 3.7603647201439514`*^9}, 
   3.7604813263056374`*^9, 3.7604815347198124`*^9, {3.7604827627667007`*^9, 
   3.7604827725997295`*^9}, {3.7604828119162483`*^9, 3.7604828164639263`*^9}, 
   3.7604828484740305`*^9, 3.7604836033043623`*^9, 3.7604837123340745`*^9, {
   3.760484670722892*^9, 3.7604846851583014`*^9}},
 CellLabel->
  "During evaluation of \
In[34]:=",ExpressionUUID->"4558691e-01c2-4c5a-b727-f64308c4253d"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"True", ",", "True", ",", "True"}], "}"}]], "Print",
 CellChangeTimes->{
  3.7603117167834387`*^9, 3.760311812935465*^9, {3.7603646482357903`*^9, 
   3.7603646645876083`*^9}, {3.7603647000666604`*^9, 3.7603647201439514`*^9}, 
   3.7604813263056374`*^9, 3.7604815347198124`*^9, {3.7604827627667007`*^9, 
   3.7604827725997295`*^9}, {3.7604828119162483`*^9, 3.7604828164639263`*^9}, 
   3.7604828484740305`*^9, 3.7604836033043623`*^9, 3.7604837123340745`*^9, {
   3.760484670722892*^9, 3.760484685171311*^9}},
 CellLabel->
  "During evaluation of \
In[34]:=",ExpressionUUID->"3247f086-7456-491e-be11-671f3ce82dea"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
},
WindowSize->{1190, 1867},
WindowMargins->{{Automatic, -1195}, {7, Automatic}},
Magnification:>1.1 Inherited,
FrontEndVersion->"11.3 for Microsoft Windows (64-bit) (March 6, 2018)",
StyleDefinitions->"Default.nb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[1510, 35, 2905, 49, 482, "Section",ExpressionUUID->"e0da43a8-4f78-4e93-a8b3-18765de35273"],
Cell[CellGroupData[{
Cell[4440, 88, 12810, 315, 891, "Input",ExpressionUUID->"3bb15814-daa3-4a07-b10a-06019d2036f3"],
Cell[CellGroupData[{
Cell[17275, 407, 1259, 31, 43, "Print",ExpressionUUID->"2b856025-571a-40de-b116-e3779473b123"],
Cell[18537, 440, 87420, 1457, 888, "Print",ExpressionUUID->"455cdd05-867f-4c4f-b251-36a0e20763ba"]
}, Open  ]]
}, Open  ]],
Cell[105984, 1901, 99, 1, 4, "PageBreak",ExpressionUUID->"5019056e-a245-40b6-b7fc-08130c911bda",
 PageBreakBelow->True]
}, Open  ]],
Cell[CellGroupData[{
Cell[106120, 1907, 1981, 63, 247, "Section",ExpressionUUID->"7490b891-9591-414f-a8a8-dc4431acf30d"],
Cell[CellGroupData[{
Cell[108126, 1974, 6890, 199, 583, "Input",ExpressionUUID->"ee4a1d0f-90f8-4362-92a2-b535a357100f"],
Cell[CellGroupData[{
Cell[115041, 2177, 9046, 275, 100, "Print",ExpressionUUID->"4558691e-01c2-4c5a-b727-f64308c4253d"],
Cell[124090, 2454, 651, 12, 23, "Print",ExpressionUUID->"3247f086-7456-491e-be11-671f3ce82dea"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature 1uTDZllOsQAXgA1v3R4pmMio *)
