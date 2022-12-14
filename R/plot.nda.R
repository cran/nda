#-----------------------------------------------------------------------------#
#                                                                             #
#  NETWORK-BASED DIMENSIONALITY REDUCTION AND ANALYSIS (NDA)                  #
#                                                                             #
#  Written by: Zsolt T. Kosztyan*, Marcell T. Kurbucz, Attila I. Katona       #
#              *Department of Quantitative Methods                            #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: October 2022                                                 #
#-----------------------------------------------------------------------------#
#' @export
plot.nda <- function(x,cuts=0.3,...){
  if ("nda" %in% class(x)){
    if (!requireNamespace("igraph", quietly = TRUE)) {
      stop(
        "Package \"igraph\" must be installed to use this function.",
        call. = FALSE
      )
    }
    if (!requireNamespace("stats", quietly = TRUE)) {
      stop(
        "Package \"stats\" must be installed to use this function.",
        call. = FALSE
      )
    }
    if (!requireNamespace("visNetwork", quietly = TRUE)) {
      stop(
        "Package \"visNetwork\" must be installed to use this function.",
        call. = FALSE
      )
    }
    R2<-G<-nodes<-edges<-NULL
    R2<-x$R
    R2[R2<cuts]<-0

    G=igraph::graph.adjacency(R2, mode = "undirected",
                              weighted = TRUE, diag = FALSE)
    nodes<-as.data.frame(igraph::V(G)$name)
    nodes$label<-rownames(x$R)
    nodes$color<-grDevices::hsv(x$membership/max(x$membership))
    nodes[x$membership==0,"color"]<-"#000000"
    colnames(nodes)<-c("id","title","color")
    edges<-as.data.frame(igraph::as_edgelist(G))
    edges <- data.frame(
      from=edges$V1,
      to=edges$V2,
      smooth=c(FALSE),
      width=igraph::E(G)$weight,
      color="#5080b1"
    )

    nw <-
      visNetwork::visIgraphLayout(
        visNetwork::visNodes(
          visNetwork::visInteraction(
            visNetwork::visOptions(
              visNetwork::visNetwork(
                nodes, edges, height = "1000px", width = "100%"),
                  highlightNearest = TRUE, selectedBy = "label"),
                  dragNodes = TRUE,
                  dragView = TRUE,
                  zoomView = TRUE,
                  hideEdgesOnDrag = FALSE),physics=FALSE, size=16,
                  borderWidth = 1,
                  font=list(face="calibri")),layout = "layout_nicely",
                  physics = TRUE, type="full"
      )
    nw
  }else{
    plot(x,...)
  }
}
