//
//  Primitives.m
//  Adapted from the code given by Borna Noureddin from BCIT
//  ass_2
//
//  Created by Choy on 2019-02-17.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Primitives.h"

@implementation Primitives

+ (id)getInstance {
    static Primitives *INSTANCE = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INSTANCE = [[self alloc] init];
    });
    return INSTANCE;
}

- (id)init {
    if (self = [super init]) {
        // Initialize any Utility variables here
    }
    return self;
}

- (Mesh *)triangle {
    Mesh *mesh;
    
    GLfloat vertices[] = {
        -0.5f, -0.5f, 0.0f, // bottom left
        0.5f, -0.5f, 0.0f, // bottom right
        0.0f,  0.5f, 0.0f // top center
    };
    
    GLfloat normals[] = {
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
    };
    
    GLfloat uvs[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.5f, 0.0f,
    };
    
    GLuint indices[] = {
        0, 1, 2
    };
    
    mesh = [[Mesh alloc] initWithVertexData:vertices numVertices:9 normals:normals uvs:uvs numUvs:6 indices:indices numIndices:3];
    
    return mesh;
}

- (Mesh *)square {
    Mesh *mesh;
    
    GLfloat vertices[] = {
        -0.5f, -0.5f, 0.0f,
        0.5f, 0.5f,  0.0f,
        -0.5f, 0.5f,  0.0f,
        0.5f, -0.5f,  0.0f,
    };
    
    GLfloat normals[] = {
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
    };
    
    GLfloat uvs[] = {
        0.0f, 1.0f, // bottom left
        1.0f, 0.0f, // top right
        0.0f, 0.0f, // top left
        1.0f, 1.0f, // bottom right
    };
    
    GLuint indices[] = {
        0, 1, 2,
        0, 3, 1
    };
    
    mesh = [[Mesh alloc] initWithVertexData:vertices numVertices:12 normals:normals uvs:uvs numUvs:8 indices:indices numIndices:6];
    
    return mesh;
}

- (Mesh *)cube {
    Mesh *mesh;
    
    GLfloat vertices[] = {
        -0.5f, -0.5f, -0.5f,
        -0.5f, -0.5f,  0.5f,
        0.5f, -0.5f,  0.5f,
        0.5f, -0.5f, -0.5f,
        -0.5f,  0.5f, -0.5f,
        -0.5f,  0.5f,  0.5f,
        
        0.5f,  0.5f,  0.5f,
        0.5f,  0.5f, -0.5f,
        -0.5f, -0.5f, -0.5f,
        -0.5f,  0.5f, -0.5f,
        0.5f,  0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        
        -0.5f, -0.5f, 0.5f,
        -0.5f,  0.5f, 0.5f,
        0.5f,  0.5f, 0.5f,
        0.5f, -0.5f, 0.5f,
        -0.5f, -0.5f, -0.5f,
        -0.5f, -0.5f,  0.5f,
        
        -0.5f,  0.5f,  0.5f,
        -0.5f,  0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f, -0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        0.5f,  0.5f, -0.5f,
    };
    
    GLfloat normals[] =
    {
        0.0f, -1.0f, 0.0f,
        0.0f, -1.0f, 0.0f,
        0.0f, -1.0f, 0.0f,
        0.0f, -1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, 1.0f,
        0.0f, 0.0f, 1.0f,
        0.0f, 0.0f, 1.0f,
        0.0f, 0.0f, 1.0f,
        -1.0f, 0.0f, 0.0f,
        -1.0f, 0.0f, 0.0f,
        -1.0f, 0.0f, 0.0f,
        -1.0f, 0.0f, 0.0f,
        1.0f, 0.0f, 0.0f,
        1.0f, 0.0f, 0.0f,
        1.0f, 0.0f, 0.0f,
        1.0f, 0.0f, 0.0f,
    };
    
    GLfloat uvs[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
    };
    
    GLuint indices[] = {
        0, 2, 1,
        0, 3, 2,
        4, 5, 6,
        4, 6, 7,
        8, 9, 10,
        8, 10, 11,
        12, 15, 14,
        12, 14, 13,
        16, 17, 18,
        16, 18, 19,
        20, 23, 22,
        20, 22, 21
    };
    
    mesh = [[Mesh alloc] initWithVertexData:vertices numVertices:72 normals:normals uvs:uvs numUvs:48 indices:indices numIndices:36];
    
    return mesh;
}

- (Mesh *)sphere:(GLint)numSlices radius:(GLfloat)radius {
    Mesh *mesh;
    
    int i;
    int j;
    int numParallels = numSlices / 2;
    int numVertices = ( numParallels + 1 ) * ( numSlices + 1 );
    int numIndices = numParallels * numSlices * 6;
    float angleStep = ( 2.0f * M_PI ) / ( ( float ) numSlices );
    
    GLfloat *vertices, *normals, *texCoords;
    GLuint *indices;
    // Allocate memory for buffers
    vertices = malloc ( sizeof ( GLfloat ) * 3 * numVertices );
    normals = malloc ( sizeof ( GLfloat ) * 3 * numVertices );
    texCoords = malloc ( sizeof ( GLfloat ) * 2 * numVertices );
    indices = malloc ( sizeof ( GLuint ) * numIndices );
    
    for ( i = 0; i < numParallels + 1; i++ )
    {
        for ( j = 0; j < numSlices + 1; j++ )
        {
            int vertex = ( i * ( numSlices + 1 ) + j ) * 3;
            
            if ( vertices )
            {
                vertices[vertex + 0] = radius * sinf ( angleStep * ( float ) i ) *
                sinf ( angleStep * ( float ) j );
                vertices[vertex + 1] = radius * cosf ( angleStep * ( float ) i );
                vertices[vertex + 2] = radius * sinf ( angleStep * ( float ) i ) *
                cosf ( angleStep * ( float ) j );
            }
            
            if ( normals )
            {
                normals[vertex + 0] = vertices[vertex + 0] / radius;
                normals[vertex + 1] = vertices[vertex + 1] / radius;
                normals[vertex + 2] = vertices[vertex + 2] / radius;
            }
            
            if ( texCoords )
            {
                int texIndex = ( i * ( numSlices + 1 ) + j ) * 2;
                texCoords[texIndex + 0] = ( float ) j / ( float ) numSlices;
                texCoords[texIndex + 1] = ( 1.0f - ( float ) i ) / ( float ) ( numParallels - 1 );
            }
        }
    }
    
    // Generate the indices
    if ( indices != NULL )
    {
        GLuint *indexBuf = indices;
        
        for ( i = 0; i < numParallels ; i++ )
        {
            for ( j = 0; j < numSlices; j++ )
            {
                *indexBuf++  = i * ( numSlices + 1 ) + j;
                *indexBuf++ = ( i + 1 ) * ( numSlices + 1 ) + j;
                *indexBuf++ = ( i + 1 ) * ( numSlices + 1 ) + ( j + 1 );
                
                *indexBuf++ = i * ( numSlices + 1 ) + j;
                *indexBuf++ = ( i + 1 ) * ( numSlices + 1 ) + ( j + 1 );
                *indexBuf++ = i * ( numSlices + 1 ) + ( j + 1 );
            }
        }
    }
    
    mesh = [[Mesh alloc] initWithVertexData:vertices numVertices:(3 * numVertices) normals:normals uvs:texCoords numUvs:(2 * numVertices) indices:indices numIndices:numIndices];
    
    return mesh;
}

@end
