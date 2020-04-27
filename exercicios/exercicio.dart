soma (int a, int b) {
  return a + b;
}
int exec(int a, int b, Function(int, int) fn){
  return fn(a, b);
}
imprimirProduto(int qtde, {String nome, double preco}){
  for( var i = 0;i < qtde; i++){
    print("O produto ${nome} tem preço R\$${preco}!!!!!");
  }
}
class Produto {
  String nome;
  double preco;

Produto({this.nome, this.preco = 9.99}); // outro exemplo de construtor
  // Produto(String nome, double preco){
  //   this.nome = nome;
  //   this.preco = preco;
  // }
}

main() {
  dynamic x = 'Teste';
  x = 123;
  x = false;
  
  print(x);

  int a = 3;
  double b = 3.1;
  bool estaChovendo = true;
  bool estaFrio = false;
  var c = 'Vc é muito legal';
  print(c is String);
    print(estaChovendo || estaFrio);

  var nomes = ['Ana', 'Bia', 'Carlos'];
  nomes.add('Daniel');
  nomes.add('Daniel');
  nomes.add('Daniel');
  print(nomes.length);
  print(nomes.elementAt(0));
  print(nomes[5]);

  Set<int> conjunto = {0, 1, 2, 3, 4, 4,4,4,4};
  print(conjunto.length);
  print(conjunto is Set);

  Map<String, double> notasDosAlunos = {
    'Ana': 9.7,
    'Bia': 9.2,
    'Carlos': 7.8,
  };

  for(var chave in notasDosAlunos.keys){
    print('chave=$chave');
  }
  for(var valor in notasDosAlunos.values){
    print('chave=$valor');
  }
  for(var registro in notasDosAlunos.entries){
    print('${registro.key} = ${registro.value}');
  }

  // var int a = 3;
  //  a= 4;
  // final int b = 3;
  // const int c = 5; 

  final r = soma(2, 3);
  print('O valor da soma é: $r');

  final result = exec(20, 30, (a, b) => a * b + 100);

  print('O resultado é $result!!!!');

  var p1 = Produto(nome: 'Lapis');
  var p2 = Produto(nome: 'Geladeira', preco: 1454.99);
  // p1.nome = 'Lapis';
  // p1.preco = 4.59;

  print("O produto ${p1.nome} tem preço R\$${p1.preco}");
  print("O produto ${p2.nome} tem preço R\$${p2.preco}");

  imprimirProduto(10, preco: p1.preco, nome: p1.nome);


}

