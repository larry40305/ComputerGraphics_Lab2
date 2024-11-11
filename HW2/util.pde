public void CGLine(float x1, float y1, float x2, float y2) {
    // TODO HW1
    // Please paste your code from HW1 CGLine.
    float dx = x2 - x1;
    float dy = y2 - y1;
    float steps = 20000;

    float x = x1;
    float y = y1;

    for(int i = 0; i <= steps; i++){
        drawPoint(x,y,color(0,0,0));
        x += dx / steps;
        y += dy / steps;
    }
}

public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height)
        return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int) y * width + (int) x;
    if (outOfBoundary(x, y))
        return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // TODO HW2 
    // You need to check the coordinate p(x,v) if inside the vertices. 
    // If yes return true, vice versa.
    boolean result = false;
    int n = vertexes.length; //numbers of vertexes

    for(int i = 0,j = n - 1; i < n; j = i++){
        float xi = vertexes[i].x, yi = vertexes[i].y; // current x, y of i
        float xj = vertexes[j].x, yj = vertexes[j].y; // previous x, y of j

        if(((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi)){
            result = !result;
        }
    }
    return result;
}

public Vector3[] findBoundBox(Vector3[] v) {
    
    
    // TODO HW2 
    // You need to find the bounding box of the vertices v.
    // r1 -------
    //   |   /\  |
    //   |  /  \ |
    //   | /____\|
    //    ------- r2

    Vector3 recordminV = new Vector3(Float.MAX_VALUE);
    Vector3 recordmaxV = new Vector3(Float.MIN_VALUE);
    
    for(Vector3 vertex : v){
        // find min
        if(vertex.x < recordminV.x) recordminV.x = vertex.x;
        if(vertex.y < recordminV.y) recordminV.y = vertex.y;
        if(vertex.z < recordminV.z) recordminV.z = vertex.z;

        // find max
        if(vertex.x > recordmaxV.x) recordmaxV.x = vertex.x;
        if(vertex.y > recordmaxV.y) recordmaxV.y = vertex.y;
        if(vertex.z > recordmaxV.z) recordmaxV.z = vertex.z;
    }
    
    Vector3[] result = { recordminV, recordmaxV };
    return result;

}

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<Vector3>();
    ArrayList<Vector3> output = new ArrayList<Vector3>();
    for (int i = 0; i < points.length; i += 1) {
        input.add(points[i]);
    }
    
    // TODO HW2
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertices of the "boundary".
    // The output is the vertices of the polygon.

    //iterate all boundary
    for(int i = 0;i < boundary.length;i++){
        output.clear();
        Vector3 start_edge = boundary[i];
        Vector3 end_edge = boundary[(i+1) % boundary.length];
        Vector3 P = input.get(input.size() - 1); //previous vertex

        for(int j = 0; j < input.size();j++){
            Vector3 Q = input.get(j); // current vertex

            if(isInside(P,start_edge,end_edge)){
                if(isInside(Q,start_edge,end_edge)){
                    output.add(Q);
                }
                else{
                    output.add(getIntersection(P,Q,start_edge,end_edge));
                }
                
            }
            else if(isInside(Q,start_edge,end_edge)){
                output.add(getIntersection(P,Q,start_edge,end_edge));
                output.add(Q);
            }
            P = Q;
        }
        input.clear();
        input.addAll(output);
    }

    

    Vector3[] result = new Vector3[output.size()];
    for (int i = 0; i < result.length; i += 1) {
        result[i] = output.get(i);
    }
    return result;
}

private boolean isInside(Vector3 p, Vector3 start, Vector3 end){
    return (end.x - start.x) * (p.y - start.y) < (end.y - start.y) * (p.x - start.x);
}

private Vector3 getIntersection(Vector3 p,Vector3 q, Vector3 start, Vector3 end){
    float a1 = q.y - p.y;
    float b1 = p.x - q.x;
    float c1 = a1*p.x + b1 * p.y;
    
    float a2 = end.y - start.y;
    float b2 = start.x - end.x;
    float c2 = a2 * start.x + b2 * start.y;

    float det = a1 * b2 - a2 * b1;
    
    float x = (b2 * c1 - b1 * c2) / det;
    float y = (a1 * c2 - a2 * c1) / det;
    return new Vector3(x,y,0);
}
