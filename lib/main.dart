import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(A());
}

class A extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5',
      home: P(),
    );
  }
}

class P extends StatefulWidget {
  const P({Key key}) : super(key: key);
  @override
  Z createState() => Z();
}

class Z extends State<P>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  List f, a, q, s;
  int i = 0;
  Widget fa;
  Timer t;
  Offset o;
  DecorationTween w;
  AnimationController ac;
  Animation<Decoration> ad;
  AudioPlayer p;
  bool v;
  IconButton ib;
  List<BoxShadow> l1 = List(), l2 = List();

  @override
  initState() {
    super.initState();
    o = Offset(65, 460);
    l1.add(bs(Colors.indigo.withAlpha(48), 9.0, 6.5));
    l2.add(bs(Colors.deepPurpleAccent.withAlpha(48), 12.5, 8.5));
    w = DecorationTween(
      begin: bd(l1, Colors.black.withAlpha(28), BorderRadius.circular(20)),
      end: bd(l2, Colors.black.withAlpha(28), BorderRadius.circular(20)));
    ac = AnimationController(vsync: this, duration: Duration(seconds: 4));
    ad = w.animate(ac);
    ac.repeat(reverse: true);
    d();
    m();
    ib = ic(Icon(Icons.volume_up));
    v = false;
    WidgetsBinding.instance.addObserver(this);
  }

  bs(Color c, double b, double s) {
    return BoxShadow(color: c, blurRadius: b, spreadRadius: s);
  }

  bd(List l, Color c, BorderRadiusGeometry r) {
    return BoxDecoration(
      boxShadow: l,
      color: c,
      borderRadius: r
    );
  }

  m() async {
    p = await AudioCache().loop("music/a.mp3");
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (p == null) return;
    if (state == AppLifecycleState.resumed) {
      if (!v) {
        p.resume();
      }
    } else {
      p.pause();
    }
  }

  d() async {
    Map d = await j();
    f=d["f"]; a=d["a"]; q=d["q"]; s=d["s"];
    u();
    t = Timer.periodic(Duration(seconds: 8), (timer) {
      i = (i + 1) % f.length;
      u();
    });
  }

  u() {
    setState(() {
      fa = KeyedSubtree(
        key: ValueKey('$i'),
        child: FlareActor(
          f[i],
          animation: a[i],
          fit: BoxFit.cover,
        ),
      );
    });
  }

  @override
  dispose() {
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: f == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    fa,
                    Positioned(
                      left: o.dx,
                      top: o.dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            o = Offset(o.dx + details.delta.dx,
                                o.dy + details.delta.dy);
                          });
                        },
                        child: DecoratedBoxTransition(
                          child: r(),
                          decoration: ad,
                        ),
                      ),
                    ),
                    b(),
                  ],
                ),
              ),
      ),
    );
  }

  b() {
    return Positioned(
      top: 15,
      left: 15,
      child: Container(
        width: 30,
        height: 30,
        child: ib,
      ),
    );
  }

  x() {
    if (v) {
      p.resume();
      setState(() {
        ib = ic(Icon(Icons.volume_up));
        v = !v;
      });
    } else {
      p.pause();
      setState(() {
        ib = ic(Icon(Icons.volume_off));
        v = !v;
      });
    }
  }

  ic(Icon i) {
    return IconButton(icon: i, onPressed: () => x());
  }

  r() {
    return Container(
      width: 300,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            tx(q, 16, FontWeight.w800),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: tx(s, 15, FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  tx(List a, double s, FontWeight w) {
    return Text(
      a[i],
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontFamily: "z",
        fontSize: s,
        fontWeight: w,
      ),
    );
  }
}

j() async {
  String d = await rootBundle.loadString("assets/d.json");
  return json.decode(d);
}
