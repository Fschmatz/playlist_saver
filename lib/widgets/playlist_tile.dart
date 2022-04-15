import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../class/playlist.dart';

class PlaylistTile extends StatefulWidget {
  @override
  _PlaylistTileState createState() => _PlaylistTileState();

  Playlist playlist;

  PlaylistTile({Key? key, required this.playlist}) : super(key: key);
}

class _PlaylistTileState extends State<PlaylistTile> {
  /* void _deletar(int id) async {
    final dbLivro = LivroDao.instance;
    final deletado = await dbLivro.delete(id);
  }*/

  /* void openBottomMenuBookSettings() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                    title: Text(
                      widget.livro.nome,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Divider(),
                  Visibility(
                    visible: widget.paginaAtual != 0,
                    child: ListTile(
                      leading: const Icon(Icons.bookmark_outline),
                      title: const Text(
                        "Marcar como para ler",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _mudarEstado(widget.livro.id, 0);
                        inOutAnimation.currentState!.animateOut();
                        Future.delayed(const Duration(milliseconds: 300), () {
                          widget.getLivrosState();
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 0,
                    child: const Divider(),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 1,
                    child: ListTile(
                      leading: const Icon(Icons.book_outlined),
                      title: const Text(
                        "Marcar como lendo",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _mudarEstado(widget.livro.id, 1);
                        inOutAnimation.currentState!.animateOut();
                        Future.delayed(const Duration(milliseconds: 300), () {
                          widget.getLivrosState();
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 1,
                    child: const Divider(),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 2,
                    child: ListTile(
                      leading: const Icon(Icons.done_outlined),
                      title: const Text(
                        "Marcar como lido",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _mudarEstado(widget.livro.id, 2);
                        inOutAnimation.currentState!.animateOut();

                        Future.delayed(const Duration(milliseconds: 300), () {
                          widget.getLivrosState();
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.paginaAtual != 2,
                    child: const Divider(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text(
                      "Editar livro",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();

                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => PgEditarLivro(
                              livro: widget.livro,
                              refreshLista: widget.getLivrosState,
                            ),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_outlined),
                    title: const Text(
                      "Deletar livro",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      showAlertDialogOkDelete(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }*/

  /* showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text(
        "Sim",
      ),
      onPressed: () {
        _deletar(widget.livro.id);
        inOutAnimation.currentState!.animateOut();
        Future.delayed(const Duration(milliseconds: 300), () {
          widget.getLivrosState();
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "Confirmação ",
      ),
      content: const Text(
        "Deletar livro ?",
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return InkWell(
     // onTap: openBottomMenuBookSettings,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: widget.playlist.cover == null
                        ? SizedBox(
                            height: 100,
                            width: 100,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.music_note_outlined,
                                size: 30,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 100,
                            width: 100,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.memory(
                                  widget.playlist.cover!,
                                  fit: BoxFit.fill,
                                  filterQuality: FilterQuality.medium,
                                  gaplessPlayback: true,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.playlist.title,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Visibility(
                        visible: widget.playlist.artist!.isNotEmpty,
                        child: Text(
                          widget.playlist.artist!,
                          style: TextStyle(
                              fontSize: 16, color: Theme.of(context).hintColor),
                        ),
                      ),
                      /*const SizedBox(
                        height: 7,
                      ),
                      Visibility(
                        visible: widget.livro.numPaginas != 0,
                        child: Text(
                          widget.livro.numPaginas.toString() + " Páginas",
                          style: TextStyle(
                              fontSize: 16, color: Theme.of(context).hintColor),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
