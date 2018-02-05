///////////////////////////////////////////////////////////////////////////////////////////////
// �ݒ�

// ���A�N�Z�T���̃T�C�Y�i�����c�j
//   �����̒l��ύX�����ꍇ�A�K��CircleMirrorObject.fx�̓����̐ݒ�����킹�ĕύX���邱��
float2 MirrorSize = { 1, 1 };

// ���̐F�iRGB�j
//   �������x��MMD�̃A�N�Z�T������p�l���Őݒ�\ 
float3 MirrorColor = { 1.0, 1.0, 1.0 };

// ���e�N�X�`���̃T�C�Y
#define WIDTH   512
#define HEIGHT  512

////////////////////////////////////////////////////////////////////////////////////////////////
// �p�����[�^�錾

// ���@�ϊ��s��
float4x4 WorldViewProjMatrix      : WORLDVIEWPROJECTION;
float4x4 WorldViewMatrix          : WORLDVIEW;

float4   MaterialDiffuse   : DIFFUSE  < string Object = "Geometry"; >;


///////////////////////////////////////////////////////////////////////////////////////////////
// ���֘A

texture MirrorRT: OFFSCREENRENDERTARGET <
    string Description = "OffScreen RenderTarget for Mirror.fx";
    int Width = WIDTH;
    int Height = HEIGHT;
    float4 ClearColor = { 1, 1, 1, 1 };
    float ClearDepth = 1.0;
    bool AntiAlias = true;
    string DefaultEffect = 
        "self = hide;"
        "CircleMirror*.x = hide;"
        "*=CircleMirrorObject.fx;";
>;

sampler MirrorView = sampler_state {
    texture = <MirrorRT>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV = CLAMP;
};


///////////////////////////////////////////////////////////////////////////////////////////////
// �I�u�W�F�N�g�`��

struct VS_OUTPUT {
    float4 Pos        : POSITION;    // �ˉe�ϊ����W
    float2 Tex        : TEXCOORD1;   // �e�N�X�`��
};

// ���_�V�F�[�_
VS_OUTPUT Mirror_VS(float4 Pos : POSITION, float2 Tex : TEXCOORD0)
{
    VS_OUTPUT Out = (VS_OUTPUT)0;
    
    Pos.xy *= MirrorSize;
    // �J�������_�̃��[���h�r���[�ˉe�ϊ�
    Out.Pos = mul( Pos, WorldViewProjMatrix );
    
    // �e�N�X�`�����W
    Out.Tex = Tex;
    
    if ( dot(WorldViewMatrix[2].xyz,WorldViewMatrix[3].xyz) > 0 ) {
        // ���̕\�̖ʂ̏ꍇ�AX���𔽓]���ĕ`�悵�Ă���̂ŁA�����Ŕ��]����B
        Out.Tex.x = 1 - Out.Tex.x;
    }
    
    return Out;
}

// �s�N�Z���V�F�[�_
float4 Mirror_PS(VS_OUTPUT IN) : COLOR0
{
    float4 color = tex2D(MirrorView, IN.Tex);
    color.rgb *= MirrorColor;
    color.a = MaterialDiffuse.a;

    float x = IN.Tex.x - 0.5;
    float y = IN.Tex.y - 0.5;

	if (x * x + y * y > 0.25)
	        color.a = 0;
	        
    return color;
}

technique MainTec {
    pass DrawObject {
        CULLMODE = NONE;
        VertexShader = compile vs_2_0 Mirror_VS();
        PixelShader  = compile ps_2_0 Mirror_PS();
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////
