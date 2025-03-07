//
//  Mesh.h
//  Adapted from Joey DeVries LearnOpenGL tutorials found at
//  https://learnopengl.com/
//  ass_2
//
//  Created by Choy on 2019-02-17.
//

#import "GLProgram.h"
#import "Texture.h"
#import "Material.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mesh : NSObject

@property GLfloat *_vertices;
@property GLfloat *_normals;
@property GLfloat *_uvs;
@property GLuint *_indices;
@property (nonatomic, strong) NSMutableArray<Texture *> *_textures;

@property GLsizei _numVertices;
@property GLsizei _numUvs;
@property GLsizei _numIndices;

@property GLKVector3 _position;
@property GLKVector3 _rotation;
@property GLKVector3 _scale;

@property Material *_material;

- (id)initWithVertexData:(GLfloat *)vertexData numVertices:(GLsizei)numVertices normals:(GLfloat *)normals uvs:(GLfloat *)uvs numUvs:(GLsizei)numUvs indices:(GLuint *)indices numIndices:(GLsizei)numIndices;

- (void)cleanUp;
- (void)draw:(GLProgram *)program;
- (void)addTexture:(Texture *)texture;

@end

NS_ASSUME_NONNULL_END
