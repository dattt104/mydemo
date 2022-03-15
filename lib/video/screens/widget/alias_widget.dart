import 'package:flutter/material.dart';

class AliasWidget extends StatelessWidget {
  const AliasWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _aliasTile(
      context,
    );
  }

  Widget _aliasTile(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 12.0,
              bottom: 4.0,
            ),
            child: Row(
              children: [
                _aliasItem(
                  context,
                  height: 70.0,
                  width: 90.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _aliasItem(
                        context,
                      ),
                      const SizedBox(height: 8.0),
                      _aliasItem(
                        context,
                      ),
                      const SizedBox(height: 8.0),
                      _aliasItem(
                        context,
                        width: 56.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _aliasItem(
    context, {
    double height = 15.0,
    double? width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
