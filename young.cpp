// {{{ includes and using
#include <iostream>
#include <tclap/CmdLine.h>
#include "itpp_ext_math.cpp"
#include "spinchain.cpp"

#if INCLUDECUDA
#include "cuda_routines.cu"
#endif // INCLUDECUDA

using namespace std;
// using namespace itpp;
using namespace itppextmath;
using namespace cfpmath;
using namespace spinchain;
// }}}
std::complex<double> Im(0,1);
int main(int argc, char* argv[]) { //{{{
// Random seed, cout configuration, etc {{{
// 	Random semilla_uran;
// 	itpp::RNG_reset(semilla_uran.strong());
//   	cout << PurityRMT::QubitEnvironmentHamiltonian(3,0.) <<endl;
// 	cout << RMT::FlatSpectrumGUE(5,.1) <<endl;
//
  cout.precision(16);
  //argc-1 porque tiene más de los necesarios y demás le quitamos uno
    itpp::cvec mivec(argc-1);
    for (int i = 1; i < argc; ++i){
        mivec[i-1] = std::atoi(argv[i]);
    }
    //cout << mivec << endl;
    apply_ising_allvsall(mivec, 1.);
    //lo de abajo sí va
    cout << mivec << endl;
    //for (int i = 0; i < argc-1; ++i) {
   	//cout << mivec[i] << endl;
    //}
  return 0;
}//}}}
