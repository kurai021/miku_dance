
texture MovieTex : ANIMATEDTEXTURE <
    // �g�p����APNG(or AGIF)�t�@�C�����w�肷��B
    //string ResourceName = "animated.gif";
    string ResourceName = "animated.gif";
>;



// �Z���t�V���h�EOFF�p
technique MainTec < string MMDPass = "object"; > {
    pass DrawObject {
        // �A�N�Z�T���`�掞�ɁA�{���̃e�N�X�`���̑���ɁA
        // ��L�̃A�j���[�V�����e�N�X�`�����g�p����悤�ɐݒ�
        Texture[0] = MovieTex;
    }
}

// �Z���t�V���h�EON�p
technique MainTec < string MMDPass = "object_ss"; > {
    pass DrawObject {
        Texture[1] = MovieTex;
    }
}
