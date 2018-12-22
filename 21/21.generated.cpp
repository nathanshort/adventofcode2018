#include <iostream>
#include <set>

using namespace std;

int main( int argc, char **argv )
{
  long long r[] = {0,0,0,0,0,0};
  int ip = 0;
  set<long long> seen;
  int ipbound = 1;
  long long prev = 0;
  
  while( 1 )
    {
      // instr 28
      // eqrr 3 0 2
      // reg2 = ( reg3 == reg0 ? 1 : 0 )
      if( ip == 28 )
	{
	  /// part 1
	  /* if( seen.size() == 0 )
	     {
	     cout << "hit 28 looking for:" << r[3] << endl;
	     break;
	     }  */

	  /// part 2
	  if( seen.find( r[3] ) != seen.end() )
	  {
	    cout << "hit 28 prev was:" << prev << endl;
	    break;
	  }
	  prev = r[3];
	  seen.insert( r[3] );
	}

      switch( ip )
	{
	  //seti
	case 0:
	  r[ipbound]=ip;
	  r[3] = 123;
	  ip=r[ipbound]+1;
	  break;


	  //bani
	case 1:
	  r[ipbound]=ip;
	  r[3] = r[3] & 456;
	  ip=r[ipbound]+1;
	  break;


	  //eqri
	case 2:
	  r[ipbound]=ip;
	  r[3] = r[3] == 72 ? 1 : 0;
	  ip=r[ipbound]+1;
	  break;


	  //addr
	case 3:
	  r[ipbound]=ip;
	  r[1] = r[3] + r[1];
	  ip=r[ipbound]+1;
	  break;


	  //seti
	case 4:
	  r[ipbound]=ip;
	  r[1] = 0;
	  ip=r[ipbound]+1;
	  break;


	  //seti
	case 5:
	  r[ipbound]=ip;
	  r[3] = 0;
	  ip=r[ipbound]+1;
	  break;


	  //bori
	case 6:
	  r[ipbound]=ip;
	  r[5] = r[3] | 65536;
	  ip=r[ipbound]+1;
	  break;


	  //seti
	case 7:
	  r[ipbound]=ip;
	  r[3] = 15028787;
	  ip=r[ipbound]+1;
	  break;


	  //bani
	case 8:
	  r[ipbound]=ip;
	  r[2] = r[5] & 255;
	  ip=r[ipbound]+1;
	  break;


	  //addr
	case 9:
	  r[ipbound]=ip;
	  r[3] = r[3] + r[2];
	  ip=r[ipbound]+1;
	  break;


	  //bani
	case 10:
	  r[ipbound]=ip;
	  r[3] = r[3] & 16777215;
	  ip=r[ipbound]+1;
	  break;


	  //muli
	case 11:
	  r[ipbound]=ip;
	  r[3] = r[3] * 65899;
	  ip=r[ipbound]+1;
	  break;


	  //bani
	case 12:
	  r[ipbound]=ip;
	  r[3] = r[3] & 16777215;
	  ip=r[ipbound]+1;
	  break;


	  //gtir
	case 13:
	  r[ipbound]=ip;
	  r[2] = 256 > r[5] ? 1 : 0;
	  ip=r[ipbound]+1;
	  break;


	  //addr
	case 14:
	  r[ipbound]=ip;
	  r[1] = r[2] + r[1];
	  ip=r[ipbound]+1;
	  break;


	  //addi
	case 15:
	  r[ipbound]=ip;
	  r[1] = r[1] + 1;
	  ip=r[ipbound]+1;
	  break;


	  //seti
	case 16:
	  r[ipbound]=ip;
	  r[1] = 27;
	  ip=r[ipbound]+1;
	  break;


	  //seti
	case 17:
	  r[ipbound]=ip;
	  r[2] = 0;
	  ip=r[ipbound]+1;
	  break;


	  //addi
	case 18:
	  r[ipbound]=ip;
	  r[4] = r[2] + 1;
	  ip=r[ipbound]+1;
	  break;


	  //muli
	case 19:
	  r[ipbound]=ip;
	  r[4] = r[4] * 256;
	  ip=r[ipbound]+1;
	  break;


	  //gtrr
	case 20:
	  r[ipbound]=ip;
	  r[4] = r[4] > r[5] ? 1 : 0;
	  ip=r[ipbound]+1;
	  break;


	  //addr
	case 21:
	  r[ipbound]=ip;
	  r[1] = r[4] + r[1];
	  ip=r[ipbound]+1;
	  break;


	  //addi
	case 22:
	  r[ipbound]=ip;
	  r[1] = r[1] + 1;
	  ip=r[ipbound]+1;
	  break;


	  //seti
	case 23:
	  r[ipbound]=ip;
	  r[1] = 25;
	  ip=r[ipbound]+1;
	  break;


	  //addi
	case 24:
	  r[ipbound]=ip;
	  r[2] = r[2] + 1;
	  ip=r[ipbound]+1;
	  break;


	  //seti
	case 25:
	  r[ipbound]=ip;
	  r[1] = 17;
	  ip=r[ipbound]+1;
	  break;


	  //setr
	case 26:
	  r[ipbound]=ip;
	  r[5] = r[2];
	  ip=r[ipbound]+1;
	  break;


	  //seti
	case 27:
	  r[ipbound]=ip;
	  r[1] = 7;
	  ip=r[ipbound]+1;
	  break;


	  //eqrr
	case 28:
	  r[ipbound]=ip;
	  r[2] = r[3] == r[0] ? 1 : 0;
	  ip=r[ipbound]+1;
	  break;


	  //addr
	case 29:
	  r[ipbound]=ip;
	  r[1] = r[2] + r[1];
	  ip=r[ipbound]+1;
	  break;


	  //seti
	case 30:
	  r[ipbound]=ip;
	  r[1] = 5;
	  ip=r[ipbound]+1;
	  break;


	}
    }

  return 0;
}
