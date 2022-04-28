# Fiedler-Vector-Scoring-Model
New graph feature selection using Fiedler vectors &amp; Score graphs to find "RNA-like" motifs

Using the Fiedler vectors, we extract two features S and E for our graphs, so that we can map the graphs into the 2D plane. A subsequent scoring model is proposed to rank graphs based on their distances from the existing graphs. The graphs with high scores are then considered "RNA-like". For more details, see our 2021 paper "A Fiedler Vector Scoring Approach for Novel RNA Motif Selection" published in Journal of Physical Chemistry.

- The feature selection step is performed in Matlab script "FeatureSelection.m"
- The scoring model is implemented in Matlab script "ScoringModel"
- An additional application of finding similar motifs for a given graph is implemented in "MotifSearch.m"
