[Mesh]
  type = MeshGeneratorMesh
  [base]
    type = FileMeshGenerator
    file = mesh.e
  []
  [frac]
    type = LowerDBlockFromSidesetGenerator
    input = base
    sidesets = 'frac'     
    new_block_id = 20
    new_block_name = 'frac'
  []
