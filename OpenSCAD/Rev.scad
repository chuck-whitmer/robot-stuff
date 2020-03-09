module RevExpansionHub()
{
	color(0.4*[1,1,1])
	{
	linear_extrude(13)
	difference()
	{
		offset(4)
		square([143-8,103-8],center=true);
		for (t=[[-64,-44],[-64,44],[64,-44],[64,44]])
		{
			translate(t)
			circle(1.7);
		}
	}
	linear_extrude(29.5)
	translate([-46,103/2-88+4])
	offset(4)
	square([100-8,88-8]);
	}
}

RevExpansionHub();