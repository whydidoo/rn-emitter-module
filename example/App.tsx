import React, {useEffect} from 'react';
import {Text, View, StyleSheet, Button} from 'react-native';
import {RnEmitterModule} from 'react-native-rn-emitter-module';

function App(): React.JSX.Element {
  useEffect(() => {
    const id = RnEmitterModule.addRNFromNativeListener((event, data) => {
      console.log(event, data);
    });

    return () => {
      RnEmitterModule.removeListener(id);
    };
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.text}>{RnEmitterModule.sum(6, 2)}</Text>
      <Button
        title="test press"
        onPress={() => RnEmitterModule.sendNativeEvent('tests message')}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  text: {
    fontSize: 40,
    color: 'green',
  },
});

export default App;
