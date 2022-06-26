# SelfAffine

A collection of simple [matlab](https://ww2.mathworks.cn/en/products/matlab.html) scripts to plot [self-affine sets](https://en.wikipedia.org/wiki/Self-similarity#:~:text=In%20mathematics%2C%20a%20self%2Dsimilar,statistical%20properties%20at%20many%20scales.) by iterating shapes with [IFS](https://en.wikipedia.org/wiki/Interval_family_system) in a deterministic way.

## Usage
Straight steps to use:

- Download or clone the repository.
- Open the scripts with [matlab](https://ww2.mathworks.cn/en/products/matlab.html)
- Change the parameters in the [`settings`](https://github.com/zfengg/SelfAffine/blob/main/SelfAffine3D.m#L6) section of the script to what you need, e.g., setting a new [IFS](https://en.wikipedia.org/wiki/Interval_family_system). Then run the scripts. 🎉

There are several predefined examples in the `Example` section of the scripts, e.g., [here](https://github.com/zfengg/SelfAffine/blob/main/SelfAffine3D.m#L34). You may uncomment the corresponding lines to play with them.

## Remark
The names of scripts explain which dimension of the IFS they are applied for.
  - [`SelfAffine3D.m`](SelfAffine3D.m): 3D self-affine set.
  - [`SelfAffine2D.m`](SelfAffine2D.m): 2D self-affine set.
  - [`SelfSimilar1D.m`](SelfSimilar1D.m): 1D self-similar set.
  - [`SelfSimilar1DHomo.m`](SelfSimilar1DHomo.m): 1D self-similar set generated from a homogeneous IFS.


