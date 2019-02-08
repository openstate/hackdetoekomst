var base = document.body.offsetWidth - Math.max(document.body.offsetWidth * 0.2, 180);

var w = base,
	h = base;

var colorscale = d3.scale.category10();

//Legend titles
var LegendOptions = ['Haarlem','Apeldoorn'];

//Data
var d = [
		  [
			{axis:"A Landbouw, bosbouw en visserij",value:0},
			{axis:"C Industrie",value:0.057663125948407},
			{axis:"F Bouwnijverheid",value:0.018209408194234},
			{axis:"G Handel",value:0.169954476479514},
			{axis:"H Vervoer en opslag",value:0.04855842185129},
			{axis:"I Horeca",value:0.057663125948407},
			{axis:"J Informatie en communicatie",value:0.027314112291351},
			{axis:"K Financiële dienstverlening",value:0.019726858877087},
			{axis:"L Verhuur en handel van onroerend goed",value:0.007587253414264},
			{axis:"M Specialistische zakelijke diensten",value:0.083459787556904},
			{axis:"N Verhuur en overige zakelijke diensten",value:0.112291350531108},
			{axis:"O Openbaar bestuur en overheidsdiensten",value:0.077389984825493},
			{axis:"P Onderwijs",value:0.07587253414264},
			{axis:"Q Gezondheids- en welzijnszorg",value:0.185128983308042},
			{axis:"R Cultuur, sport en recreatie",value:0.034901365705615},
			{axis:"S Overige dienstverlening",value:0.024279210925645}
		  ],
		  [
			{axis:"A Landbouw, bosbouw en visserij",value:0.002143622722401},
			{axis:"C Industrie",value:0.07395498392283},
			{axis:"F Bouwnijverheid",value:0.042872454448017},
			{axis:"G Handel",value:0.143622722400857},
			{axis:"H Vervoer en opslag",value:0.026795284030011},
			{axis:"I Horeca",value:0.042872454448017},
			{axis:"J Informatie en communicatie",value:0.02465166130761},
			{axis:"K Financiële dienstverlening",value:0.062165058949625},
			{axis:"L Verhuur en handel van onroerend goed",value:0.006430868167203},
			{axis:"M Specialistische zakelijke diensten",value:0.05037513397642},
			{axis:"N Verhuur en overige zakelijke diensten",value:0.136120042872454},
			{axis:"O Openbaar bestuur en overheidsdiensten",value:0.126473740621651},
			{axis:"P Onderwijs",value:0.04930332261522},
			{axis:"Q Gezondheids- en welzijnszorg",value:0.181136120042872},
			{axis:"R Cultuur, sport en recreatie",value:0.019292604501608},
			{axis:"S Overige dienstverlening",value:0.011789924973205}
		  ]
		];

//Options for the Radar chart, other than default
var mycfg = {
  w: w,
  h: h,
  maxValue: 0.2,
  levels: 6,
  ExtraWidthX: (document.body.offsetWidth - base)
}

//Call function to draw the Radar chart
//Will expect that data is in %'s
RadarChart.draw("#chart", d, mycfg);

////////////////////////////////////////////
/////////// Initiate legend ////////////////
////////////////////////////////////////////

var svg = d3.select('#body')
	.selectAll('svg')
	.append('svg')
	.attr("width", w + mycfg.ExtraWidthX)
	.attr("height", h)

//Create the title for the legend
var text = svg.append("text")
	.attr("class", "title")
	.attr('transform', 'translate(90,0)')
	.attr("x", w - 70)
	.attr("y", 10)
	.attr("font-size", "12px")
	.attr("fill", "#404040")
	.text("Werknemers per SBI");

//Initiate Legend
var legend = svg.append("g")
	.attr("class", "legend")
	.attr("height", 100)
	.attr("width", 200)
	.attr('transform', 'translate(90,20)')
	;
	//Create colour squares
	legend.selectAll('rect')
	  .data(LegendOptions)
	  .enter()
	  .append("rect")
	  .attr("x", w - 65)
	  .attr("y", function(d, i){ return i * 20;})
	  .attr("width", 10)
	  .attr("height", 10)
	  .style("fill", function(d, i){ return colorscale(i);})
	  ;
	//Create text next to squares
	legend.selectAll('text')
	  .data(LegendOptions)
	  .enter()
	  .append("text")
	  .attr("x", w - 52)
	  .attr("y", function(d, i){ return i * 20 + 9;})
	  .attr("font-size", "11px")
	  .attr("fill", "#737373")
	  .text(function(d) { return d; })
	  ;