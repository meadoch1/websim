import * as d3 from "d3"
import {joinChannel} from "./socket.js"

export default class Sim {
    constructor(socket, root, xmax, ymax) {
        this.socket = socket;

        const width = Math.max(700, innerWidth),
              height = Math.max(500, innerHeight)

        var x = d3.scaleLinear()
            .domain([0,xmax])
            .range([0, width]);

        var y = d3.scaleLinear()
            .domain([0,ymax])
            .range([height, 0]);

        this.svg = d3.select(root).append("svg")
            .attr("width", width)
            .attr("height", height)
            .append("g");

        let channel = socket.channel("sim:boid", {})
        channel.join()
            .receive("ok", resp => {
                console.log("Joined successfully", resp);
                channel.on("update", (data) => {
                    this.repaintSvg(data.data);
                })
            })
            .receive("error", resp => { console.log("Unable to join", resp) })

        socket
    }

    repaintSvg(data) {
        console.log("Repainting");
        console.log(data);
        var circle = this.svg.selectAll( "circle" )
            .data(data);
        circle.exit().remove();

        circle.enter()
            .append("circle")
            .attr( "r", "2.5" )
            .merge(circle)
            .attr( "cx", function(d) { return d.x } )
            .attr( "cy", function(d) { return d.y } );
    }


}
