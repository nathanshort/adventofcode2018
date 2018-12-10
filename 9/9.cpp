#include <iostream>
#include <list>
#include <map>

using namespace std;

typedef long long score_t;


/// find max value in a map
score_t max_score( const map<int,score_t> &scores )
{
  score_t max = 0;
  for( auto iter = scores.begin(); iter != scores.end(); ++iter )
    {
      if( iter->second > max )
      { max = iter->second; }
    }
  return max;
}


/// circular linked list composed of a standard list.
/// templated on list type - cause...why not
template <typename T> class CircleList
{
public: 

  CircleList( void )
  { iter = data.begin(); }
  
  void insert_current( const T &item )
  { iter = data.insert( iter, item ); }

  void erase_current( void )
  { iter = data.erase( iter ); }

  T current( void )
  { return *iter; }
  
  void advance( int num )
  {
    for( int next = 0; next < num; next++ )
      {
	if( iter == data.end() )
	  {
	    iter = data.begin();
	    next--;
	    continue;
	  }
	iter++;
      }
  }

  void back_up( int num )
  {
    for( int i = 0; i < num; i++ )
      {
	if( iter == data.begin() )
	  { iter = data.end(); }
	iter--;
      }
  }

  
private:
  
  list<T> data;
  typename list<T>::iterator iter;
  
};




int main( int argc, char **argv )
{
  int num_marbles = atoi( argv[1] ),
    num_elves = atoi( argv[2] ),
    elf_number = 1;
  
  CircleList<int> marbles;
  marbles.insert_current( 0 );

  map<int,score_t> scores;
    
  for( int marble = 1; marble < num_marbles; marble++,
	 elf_number = ( elf_number + 1 ) % num_elves )
    {
      if( ! ( marble % 23 ) )
      {
	marbles.back_up( 7 );
	int marble_to_remove = marbles.current();
	marbles.erase_current();
	  
	score_t score = marble + marble_to_remove;
	auto existing_elf = scores.find( elf_number );
	if( existing_elf != scores.end() )
	{ existing_elf->second = existing_elf->second + score; }
	else
	{ scores.insert( make_pair( elf_number, score ) ); }
      }
      else
      {
	marbles.advance( 2 );
	marbles.insert_current( marble );
      }
    }

  cout << max_score( scores ) << endl;
  return 0;
}
  
