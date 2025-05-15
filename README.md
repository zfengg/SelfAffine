# SelfAffine

A collection of simple [matlab](https://ww2.mathworks.cn/en/products/matlab.html) scripts to plot [self-affine sets](https://en.wikipedia.org/wiki/Self-similarity#:~:text=In%20mathematics%2C%20a%20self%2Dsimilar,statistical%20properties%20at%20many%20scales.) by iterating shapes with [IFS](https://en.wikipedia.org/wiki/Iterated_function_system) in a deterministic way. For a probabilistic way, please refer to [zfengg/PlotIFS.jl](https://zfengg.github.io/assets/PlotIFS.html).

## Usage
Straight steps to use:

- Download or clone this repository.
- Open the scripts with [matlab](https://ww2.mathworks.cn/en/products/matlab.html).
- Change the parameters in the [`settings`](https://github.com/zfengg/SelfAffine/blob/main/SelfAffine3D.m#L6) section of the script to what you need, e.g., defining a new [IFS](https://en.wikipedia.org/wiki/Iterated_function_system). Then run the scripts. 🎉

There are several predefined examples in the `Example` section of the scripts, e.g., [here](https://github.com/zfengg/SelfAffine/blob/main/SelfAffine3D.m#L34). You may uncomment the corresponding lines to play with them.

## Simple documentation
The names of scripts explain which dimension of the IFS they are applied for.
  - [`SelfAffine3D.m`](SelfAffine3D.m): 3D self-affine set.
  - [`SelfAffine2D.m`](SelfAffine2D.m): 2D self-affine set.
  - [`SelfSimilar1D.m`](SelfSimilar1D.m): 1D self-similar set.
  - [`SelfSimilar1DHomo.m`](SelfSimilar1DHomo.m): 1D self-similar set generated from a homogeneous IFS.

Also, some scripts for special purposes are included in the folder [`utils`](utils).

## Some examples
### Basic plots
![Inhomo1D](https://user-images.githubusercontent.com/42152221/175815959-5b924c99-22a6-49d8-a548-7154033dc1eb.png)
![FengWangCarpet](https://user-images.githubusercontent.com/42152221/175815993-e5e75c84-36d9-47bb-9f6a-b8a24c795b65.png)
![SelfaffineGasket](https://user-images.githubusercontent.com/42152221/175816032-8827f434-7990-47b1-9f4f-6e8b736a0c2d.png)
![Attenna](https://user-images.githubusercontent.com/42152221/175816018-75e2fda2-f7a4-43ac-a3e2-3dac95e2a070.png)
![SierpinskiPyramid](https://user-images.githubusercontent.com/42152221/175816060-2802c138-533a-49c4-80b0-a7648f43fdf1.png)
![Cantor3D](https://user-images.githubusercontent.com/42152221/175816058-148a87e8-01c5-4e58-a02a-f707e5f056d9.png)
![BaranskiSponge](https://user-images.githubusercontent.com/42152221/175816008-3ce60591-a6a8-413a-a693-1f7b48238675.png)

### Utils
![nested](https://user-images.githubusercontent.com/42152221/195899890-c710096e-d218-4e5a-991e-a560b88b5dc2.png)
![distanceCircles](https://user-images.githubusercontent.com/42152221/195899520-c4f304d7-1b65-480f-bc9e-339b34d0bf68.png)
![percolation](https://user-images.githubusercontent.com/42152221/195900524-00a318d4-46b9-4c6a-ba98-6df491e7d42c.png)
![nonoverlap-OneFourth-itr3](https://github.com/zfengg/SelfAffine/assets/42152221/5c9318e4-d1be-4eae-9762-d51f3457e0a4)
