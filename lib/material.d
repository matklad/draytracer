module lib.material;

import lib.color;

alias immutable(Material) IMaterial;

immutable class Material {
    IColor ambient, diffuse, specular;
    immutable(double) phong;

    this(IColor ambient, IColor diffuse, IColor specular,
         immutable(double) phong) immutable {
        this.ambient = ambient;
        this.diffuse = diffuse;
        this.specular = specular;
        this.phong = phong;
    }

    private static immutable(Material) s() {
        return new immutable(Material)(Color.white, Color.white, Color.white, 4);
    }

    static {
        immutable simple = s(); //does not compute without function call =(
    }
}
